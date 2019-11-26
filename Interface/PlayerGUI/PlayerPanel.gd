extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_size(Vector2(OS.get_window_size().x, 64 + 32))
	if get_tree().is_network_server():
		queue_free()
