extends KinematicBody2D

export var speed = 200
export var BLOCK_SIZE = 64
export var DIFF = 32

var world = null

puppet var puppet_pos = Vector2()

var new_pos = Vector2()
var last_pos = Vector2()
var player_cell = Vector2()

var scroll_scene = preload("res://Interface/DialogGUI/EnemyDialog.tscn")
var arrow_dialog_scene = preload("res://Interface/DialogGUI/ArrowDialog.tscn")

var settings = {
	name = "name",
	id = 0,
	rest_of_bonfire = 0,
	have_a_torch = false,
	stuck = false
}

signal increase_score(dt)
signal clicked(pawn)
signal kill()

func _ready():
	set_as_toplevel(true)
	
	puppet_pos = position
	new_pos = position
	last_pos = position
	
	move_and_slide(Vector2(0,0)) # to prevent unnecessary motion in start
	
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
		TasksArchives.create_for_player(self)
		
	settings["texture"] = $AnimatedSprite.frames.get_frame("stay_forward", 0)
	scale = Vector2(0.5, 0.5)

func setup(world_, id_, name_, spawn_pos):
	world = world_
	settings.name = name_
	settings.id = id_
	position = spawn_pos

func _physics_process(delta):
	if is_network_master():
		if not settings.stuck:
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
		$AnimatedSprite.animation = "move_forward"
		last_pos = position
		new_pos.x = position.x + BLOCK_SIZE * x
		new_pos.y = position.y + BLOCK_SIZE * y
		if settings["rest_of_bonfire"] != 0:
			settings["rest_of_bonfire"] -= 1

func make_puppet_step(puppet_pos):
	var step = puppet_pos - position
	if step != Vector2(0, 0):
		
		make_step(1 if step.x > 0 else 0 if step.x == 0 else -1,
				  1 if step.y > 0 else 0 if step.y == 0 else -1)

func move_player():
	if get_slide_count() != 0:
		var collision = get_slide_collision(0)
		new_pos = last_pos
		
	var velocity = (new_pos - position).normalized() * speed
	if (new_pos - position).length() > 5:
		velocity = move_and_slide(velocity)
	elif position != new_pos:
		position.x = new_pos.x
		position.y = new_pos.y
		player_cell = (position + Vector2(DIFF, DIFF)) / BLOCK_SIZE
		$AnimatedSprite.animation = "stay_forward"
			
	if is_network_master():
		if settings["rest_of_bonfire"] == 0:
			$Light2D.set_texture_scale(1.96)
		else:
			$Light2D.set_texture_scale(2.76)
		rset("puppet_pos", position)


remotesync func hit_bonfire(bonfire):
	if settings["have_a_torch"]:
		settings["rest_of_bonfire"] = 10

remotesync func hit_torch(torch):
	settings["have_a_torch"] = true
	update_score(ScoreSettings.get_value("torch"))

# only master can add items
master func add_item(name, path):
	$Camera2D/CanvasLayer/PlayerPanel.add_item(name, path)

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
		"position_x" : position.x,
		"position_y" : position.y,
		"settings" : settings
		}
		
func load_player(_pos, _settings):
	position = _pos
	settings = _settings