extends TileMap

export(Array, PackedScene) var Scenes
export var scenes_dictionary = {}
export var name_dictionary = {}

signal ready_to_arrange(world)

var BLOCK_SIZE = 64
var DIFF = 32

# height and width will init from input
var height
var width

var map
var exit_pos = Vector2()
var items_dict = {}
var spawn_positions = []

func init(path, is_gen):
	if get_tree().is_network_server():
		if not is_gen:
			read_map(path)
		else:
			gen_map()
			print(map)
		rpc("reload_map", map, exit_pos, spawn_positions)
		material.set_light_mode(0) # Normal mode
	else:
		read_map("res://Src/default_maze.tres")
	setup()

func setup():
	clear_map()
	draw_map(map)
	$Paths.init(map, exit_pos)

func clear_map():
	clear()
	fix_invalid_tiles()
	$Paths.clear()
	$Paths.fix_invalid_tiles() 

func gen_map():
	var generator = load("res://bin/GDMazeGenerator.gdns").new()
	map = generator.generate(Vector2(30, 30))
	height = 52
	width = 52
	
	for i in range(map.size()):
		for j in range(map[0].size()):
			inspect_cell(i, j)

func read_map(path):
	var file = File.new()
	file.open(path, file.READ)
	var n = file.get_csv_line(" ")
	height = n[0] as int
	width = n[1] as int
	map = $Paths.create_2d_array(n[0], n[1])
	
	for i in range(n[0]):
		var line = file.get_csv_line(" ")
		for j in range(line.size()):
			map[i][j] = line[j]
			inspect_cell(i, j)

func inspect_cell(i, j):
	if map[i][j] == "S":
		map[i][j] = "."
		add_spawn_pos(Vector2(j * BLOCK_SIZE + DIFF, i * BLOCK_SIZE + DIFF))
	if map[i][j] == "E":
		exit_pos = Vector2(j, i)

func draw_map(map):
	for i in range(map.size()):
		for j in range(map[i].size()):
			var type = map[i][j]
			if (type == "#"):
				set_cell(j, i, 1)
			else:
				set_cell(j, i, 0)
			if type != "." and type != "#" and scenes_dictionary.has(type):
				var item = Scenes[scenes_dictionary[map[i][j]]].instance()
				add_child(item)
				item.position = Vector2(j * BLOCK_SIZE + DIFF, i * BLOCK_SIZE + DIFF)
				items_dict[item.position] = item

# Vectro2(from) with normal coordinate (i, j)
remotesync func draw_path(from, steps = -1):
	$Paths.draw(from, steps)

remote func reload_map(map_, exit, spawn):
	map = map_
	exit_pos = exit
	spawn_positions = spawn
	setup()
	emit_signal("ready_to_arrange", self)

func add_spawn_pos(pos):
	spawn_positions.append(pos)
