extends KinematicBody2D

export var speed = 200
export var BLOCK_SIZE = 64
export var DIFF = 32

var world = null

puppet var puppet_pos = Vector2()
remotesync var sync_with_server = true  # false if player don't take a step on server

var new_pos = Vector2()
var last_pos = Vector2()  # every moment must be fit cell
var player_cell = Vector2()


var scroll_scene = preload("res://Interface/DialogGUI/EnemyDialog.tscn")
var arrow_dialog_scene = preload("res://Interface/DialogGUI/ArrowDialog.tscn")

var settings = {
	name = "name",
	id = 0, #  don't use it!! FIXME
	rest_of_bonfire = 0,
	have_a_torch = false,
	stuck = false,
	arrow_amount = 0
}

signal increase_score(dt)
signal clicked(pawn)
signal kill()

# use in _ready
var _complited_eneme_tasks = []
var _complited_arrow_tasks = []

func _ready():
	set_as_toplevel(true)
	
	new_pos = position
	move_and_slide(Vector2(0,0))  # to prevent unnecessary motion in start (a few changing position)
	position = new_pos  # remove changing
	puppet_pos = position
	last_pos = position
	
	if is_network_master():
		$Camera2D.make_current()
		$Camera2D/CanvasLayer/PlayerPanel.setup(self)
	else:
		# anyway deleted but will update material light mode
		$Light2D.queue_free()
		$Camera2D.queue_free()
		$Camera2D/CanvasLayer/PlayerPanel.queue_free()
		
	if get_tree().is_network_server():
		$Camera2D/ParallaxBackground/Sprite.queue_free()
		material.set_light_mode(0) #Normal
		TasksArchives.create_for_player(self, _complited_eneme_tasks, _complited_arrow_tasks)
		
	settings["texture"] = $AnimatedSprite.frames.get_frame("stay_forward", 0)
	

func setup(world_, id_, name_, spawn_pos):
	world = world_
	settings.name = name_
	settings.id = id_
	position = spawn_pos

func set_complited_tasks(_complited_enemy = [], _complited_arrow = []):
	_complited_eneme_tasks = _complited_enemy
	_complited_arrow_tasks = _complited_arrow

func _physics_process(delta):
	if is_network_master():
		if not settings.stuck and sync_with_server:
			if Input.is_action_pressed("ui_left"):
				make_step(-1, 0)
			if Input.is_action_pressed("ui_right"):
				make_step(1, 0)
			if Input.is_action_pressed("ui_down"):
				make_step(0, 1)
			if Input.is_action_pressed("ui_up"):
				make_step(0, -1)
	else:
		# add check on permission for move
		make_puppet_step(puppet_pos)
	move_player()

func make_step(x, y):
	if new_pos == position: #if player don't motion
		if is_network_master():
			rset("sync_with_server", true)
		$AnimatedSprite.animation = "move_forward"
		last_pos = position
		new_pos.x = position.x + BLOCK_SIZE * x
		new_pos.y = position.y + BLOCK_SIZE * y
		if settings["rest_of_bonfire"] != 0:
			settings["rest_of_bonfire"] -= 1

var last_puppet_pos = puppet_pos

func make_puppet_step(puppet_pos):
	if last_puppet_pos == puppet_pos:
		return
	last_puppet_pos = puppet_pos
	var step = puppet_pos - position
	if step != Vector2(0, 0):
		make_step(1 if step.x > 0 else 0 if step.x == 0 else -1,
				  1 if step.y > 0 else 0 if step.y == 0 else -1)

func move_player():
	if get_slide_count() != 0:
		new_pos = last_pos
		
	var velocity = (new_pos - position).normalized() * speed
	if (new_pos - position).length() > 5:
		velocity = move_and_slide(velocity)
	elif position != new_pos:
		position.x = new_pos.x
		position.y = new_pos.y
		player_cell = (position + Vector2(DIFF, DIFF)) / BLOCK_SIZE
		$AnimatedSprite.animation = "stay_forward"
		if get_tree().is_network_server():
			rset("sync_with_server", true)
	
	if is_network_master():
		if settings["rest_of_bonfire"] == 0:
			$Light2D.set_texture_scale(1.96)
		else:
			$Light2D.set_texture_scale(2.76)
		rset_unreliable("puppet_pos", position)

func _on_SyncTimer_timeout():
	if is_network_master():
		rpc_unreliable("_sync_pos", new_pos)

puppet func _sync_pos(pos):
	set_physics_process(false)
	if abs(position.x - pos.x) > (BLOCK_SIZE - 1) or abs(position.y - pos.y) > (BLOCK_SIZE - 1):
		position = pos
		new_pos = pos
	set_physics_process(true)

remotesync func hit_bonfire():
	if settings["have_a_torch"]:
		settings["rest_of_bonfire"] = 10

remotesync func hit_torch():
	settings["have_a_torch"] = true
	update_score(ScoreSettings.get_value("torch"))

remotesync func hit_arrow():
	settings["arrow_amount"] += 1

remotesync func remove_arrow():
	settings["arrow_amount"] -= 1

# only master can add items
master func add_item(name):
	$Camera2D/CanvasLayer/PlayerPanel.add_item(name)

func get_next_enemy_task(lvl):
	return TasksArchives.get_next_enemy_task(self, lvl)

var scroll = null

func set_task_to_scroll(task):
	scroll = scroll_scene.instance()
	scroll.set_task(task)
	scroll.connect("correct_answer", self, "correct_answer")
	world.add_child(scroll)
	scroll.rect_position += position

var arrow_dialog = null

func set_arrow_task(task):
	$Camera2D/CanvasLayer/ArrowDialog.set_task(task)
	$Camera2D/CanvasLayer/ArrowDialog.show()

var current_enemy_lvl = 0

master func hit_lion(task):
	set_task_to_scroll(task)
	current_enemy_lvl = 1

	settings.stuck = true
	$Light2D.hide()

master func hit_dragon(task):
	set_task_to_scroll(task)
	current_enemy_lvl = 2
	
	settings.stuck = true
	$Light2D.hide()

# callde only on player
func correct_answer():
	scroll.queue_free()
	settings.stuck = false
	$Light2D.show()
	
	rpc_id(1, "remote_update_score", ScoreSettings.get_value("lion" if current_enemy_lvl == 1 else "dragon"))
	emit_signal("kill")

func _on_Player_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("clicked", self)

func update_score(dt):
	if get_tree().is_network_server():
		emit_signal("increase_score", dt)
		
remote func remote_update_score(dt):
	if get_tree().is_network_server():
		emit_signal("increase_score", dt)

func get_settings():
	return settings

func save():
	return {
		"name" : settings.name,
		"position_x" : last_pos.x,
		"position_y" : last_pos.y,
		"settings" : settings,
		"complited_tasks" : TasksArchives.save_complited_tasks(self)
		}
		
func set_settings(_settings):
	settings = _settings

