extends TileMap

export(Array, PackedScene) var Scenes
export var scenes_dictionary = {}
export var name_dictionary = {}

var BLOCK_SIZE = 64
var DIFF = 32

# height and width will init from input
var height
var width

var map
var items_dict = {}
var spawn_positions = []

func _ready():
	load_map("C:/Users/Dmitry/Desktop/GODOT PICTURE/GDMaze.txt")
	draw_map(map)
	if get_tree().is_network_server():
		material.set_light_mode(0) # Normal mode

func _physics_process(delta):
	pass

func load_map(patch):
	var file = File.new()
	file.open(patch, file.READ)
	var n = file.get_csv_line(" ")
	height = n[0] as int
	width = n[1] as int
	
	map = create_2d_array(n[0], n[1])
	
	for i in range(n[0]):
		var line = file.get_csv_line(" ")
		for j in range(line.size()):
			map[i][j] = line[j]
			if map[i][j] == "S":
				add_spawn_pos(Vector2(j * BLOCK_SIZE + DIFF, i * BLOCK_SIZE + DIFF))

func draw_map(map):
	for i in range(map.size()):
		for j in range(map[i].size()):
			var type = map[i][j]
			if (type as int == 0):
				set_cell(j, i, 0)
			else:
				set_cell(j, i, 1)
			if type != "0" and type != "1" and scenes_dictionary.has(type):
				var item = Scenes[scenes_dictionary[map[i][j]]].instance()
				add_child(item)
				item.position = Vector2(j * BLOCK_SIZE + DIFF, i * BLOCK_SIZE + DIFF)
				items_dict[item.position] = item
				#item.connect("hit_" + name_dictionary[type], $Player, "hit_" + name_dictionary[type])

func add_spawn_pos(pos):
	spawn_positions.append(pos)

func create_2d_array(n, m):
	var arr = []
	for i in range(n):
		arr.append([])
		arr[i].resize(m)
	return arr
