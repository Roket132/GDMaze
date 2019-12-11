extends MarginContainer

var pl_ref = null
var items_cnt = 0
var inv_path = "Panel/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Inv_%/Inv_%"
var lab_path = "Panel/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Inv_%/Lab_%"

var label_weight = 11

var inventory_dict = {
	torch = 0,
	arrow = 1
}

var icons_dict = {
	"torch" : "res://StaticObjects/sprites/torch_off.png",
	"arrow" : "res://StaticObjects/sprites/arrow.png"
	}

var cnt_dict = {}

func _ready():
	set_size(Vector2(OS.get_window_size().x, 64 + 32))
	
	UsingItemsLambdas.connect("del_item", self, "del_item")

func setup(player_ref):
	UsingItemsLambdas.pl_ref = player_ref
	
	if player_ref.settings["have_a_torch"]:
		add_item("torch")
	for i in player_ref.settings["arrow_amount"] as int:
		add_item("arrow")

func get_item_pos(name):
	if not name in inventory_dict:
		inventory_dict[name] = items_cnt
		items_cnt += 1
	return inventory_dict[name]

func add_item(name):
	print("add item")
	var inv_node = get_node(inv_path.replace("%", str(get_item_pos(name))))
	var lab_node = get_node(lab_path.replace("%", str(get_item_pos(name))))
	if not name in cnt_dict or cnt_dict[name] == 0:
		cnt_dict[name] = 1
		inv_node.icon = load(icons_dict[name])
		lab_node.text = "Кол-во: 1  "
		inv_node.connect("pressed", UsingItemsLambdas, name)
	else:
		cnt_dict[name] += 1
		
		lab_node.text = align_text("Кол-во: " + str(cnt_dict[name]), label_weight)
	
func align_text(text, cnt):
	while text.length() != cnt:
		text += " "
	return text
	
func del_item(name):
	var inv_node = get_node(inv_path.replace("%", str(get_item_pos(name))))
	var lab_node = get_node(lab_path.replace("%", str(get_item_pos(name))))
	if name in cnt_dict:
		cnt_dict[name] -= 1
		if cnt_dict[name] == 0:
			inv_node.icon = null
			lab_node.text = "" # yes! 11 spaces
			inv_node.disconnect("pressed", UsingItemsLambdas, name)
		else:
			lab_node.text = align_text("Кол-во: " + str(cnt_dict[name]), label_weight)
