extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_size(Vector2(OS.get_window_size().x, 64 + 32))
	if get_tree().is_network_server():
		queue_free()
	
var items_cnt = 0

var inv_path = "Panel/HBoxContainer/VBoxContainer/HBoxContainer/InvContainer/Inv_"
		
var inventory_dict = {
	torch = 0,
	arrow = 1
}

var cnt_dict = {}
		
func get_item_pos(name):
	if not name in inventory_dict:
		inventory_dict[name] = items_cnt
		items_cnt += 1
	return inventory_dict[name]

func add_item(name, path):
	if not name in cnt_dict or cnt_dict[name] == 0:
		var inv_node = get_node(inv_path + str(get_item_pos(name)))
		cnt_dict[name] = 1
		inv_node.icon = load(path)
		inv_node.connect("pressed", UsingItemsLambdas, name)
	else:
		pass
		
