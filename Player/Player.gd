extends KinematicBody2D

export var speed = 200
export var step_size = 160

var new_pos = Vector2()
var velocity = Vector2()
var last_pos = Vector2()
var player_cell = Vector2()

var settings = {
	rest_of_bonfire = 0,
	have_a_torch = false
}

func _ready():
	new_pos = position
	last_pos = position

func _input(event):
	if event.is_action_pressed("ui_left"):
		make_step(-1, 0)
	if event.is_action_pressed("ui_right"):
		make_step(1, 0)
	if event.is_action_pressed("ui_down"):
		make_step(0, 1)
	if event.is_action_pressed("ui_up"):
		make_step(0, -1)

func _physics_process(delta):
	move_player()
	player_cell = (position + Vector2(32,32)) / 64

func make_step(x, y):
	if new_pos == position:
		$AnimatedSprite.animation = "move_forward"
		last_pos = position
		new_pos.x = position.x + step_size * x
		new_pos.y = position.y + step_size * y
	if settings["rest_of_bonfire"] != 0:
		settings["rest_of_bonfire"] -= 1

func move_player():
	if get_slide_count() != 0:
		var collision = get_slide_collision(0)
		print("Collided with: ", collision.collider.name)
		new_pos = last_pos
		
	velocity = (new_pos - position).normalized() * speed
	if (new_pos - position).length() > 5:
		velocity = move_and_slide(velocity)
	elif position != new_pos:
		position.x = new_pos.x
		position.y = new_pos.y
		$AnimatedSprite.animation = "stay_forward"
		
	if settings["rest_of_bonfire"] == 0:
		$Camera2D.zoom = Vector2(0.5, 0.5)
	else:
		$Camera2D.zoom = Vector2(0.643, 0.643)

func hit_bonfire():
	if settings["have_a_torch"]:
		settings["rest_of_bonfire"] = 10

func hit_torch():
	settings["have_a_torch"] = true
	

