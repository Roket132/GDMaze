extends KinematicBody2D

export var speed = 200
export var BLOCK_SIZE = 64
export var DIFF = 32

var world = null

puppet var puppet_pos = Vector2()

var new_pos = Vector2()
var last_pos = Vector2()
var player_cell = Vector2()

var scroll_scene = preload("res://Interface/DialogGUI/Dialog.tscn")

var settings = {
	name = "name",
	rest_of_bonfire = 0,
	have_a_torch = false,
	stuck = false
}

signal clicked(pawn)

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
		
	settings["texture"] = $AnimatedSprite.frames.get_frame("stay_forward", 0)

func setup(world_, name_):
	world = world_
	settings.name = name_

func _physics_process(delta):
	
	print("pos = ", position)
	
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

func set_player_name(name):
	settings.player_name = name

remotesync func hit_bonfire(bonfire):
	if settings["have_a_torch"]:
		settings["rest_of_bonfire"] = 10

remotesync func hit_torch(torch):
	settings["have_a_torch"] = true

# only master can add items
master func add_item(name, path):
	$Camera2D/CanvasLayer/PlayerPanel.add_item(name, path)

master func hit_lion(text):
	var scroll = scroll_scene.instance()
	scroll.set_text(text)
	world.add_child(scroll)
	scroll.rect_position += position
	
	settings.stuck = true
	$Light2D.hide()

func _on_Player_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("clicked", self)
