extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_size(Vector2(OS.get_window_size().x, 64 + 32))
	if get_tree().is_network_server():
		queue_free()
	
var item_cnt = 0

var inv_path = "Panel/HBoxContainer/VBoxContainer/HBoxContainer/InvContainer/Inv_"
		
var inventory_dict = {
	torch = 0,
	arrow = 1
}
		
func get_item_pos(name):
	if not name in inventory_dict:
		inventory_dict[name] = item_cnt
		item_cnt += 1
	return inventory_dict[name]

func add_item(name, path):
	var pos = get_item_pos(name)
	get_node(inv_path + str(pos)).icon = load(path)
	
