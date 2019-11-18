extends TileMap

export(Array, PackedScene) var Scenes
export var scenes_dictionary = {}
export var name_dictionary = {}

var BLOCK_SIZE = 64
var DIFF = 32

var map

func _ready():	
	load_map("C:/Users/Dmitry/Desktop/GODOT PICTURE/GDMaze.txt")
	draw_map(map)

func _physics_process(delta):
	pass

func load_map(patch):
	var file = File.new()
	file.open(patch, file.READ)
	var n = file.get_csv_line(" ")
	map = create_2d_array(n[0], n[1])
	
	for i in range(n[0]):
		var line = file.get_csv_line(" ")
		for j in range(line.size()):
			map[i][j] = line[j]

func draw_map(map):
	for i in range(map.size()):
		for j in range(map[i].size()):
			var type = map[i][j]
			if (type as int == 0):
				set_cell(i, j, 0)
			else:
				set_cell(i, j, 1)
			if type != "0" and type != "1":
				var item = Scenes[scenes_dictionary[map[i][j]]].instance()
				add_child(item)
				print(i," ", j)
				item.position = Vector2(j * BLOCK_SIZE + DIFF, i * BLOCK_SIZE + DIFF)
				item.connect("hit_" + name_dictionary[type], $Player, "hit_" + name_dictionary[type])

func create_2d_array(n, m):
	var arr = []
	for i in range(n):
		arr.append([])
		arr[i].resize(m)
	return arr