extends TileMap

export(Array, PackedScene) var Scenes
export var scenes_dictionary = {}
export var name_dictionary = {}

signal ready_to_arrange(world)
signal maze_generated()

var BLOCK_SIZE = 64
var DIFF = 32

# height and width will init from input
var height
var width

var map  # startly map without changing
var exit_pos = Vector2()
var items_by_position = {}

var player_in_game = 0
var spawn_positions = []

var generator = preload("res://bin/GDMazeGenerator.gdns").new()
var thread_load_map

func init(path, is_gen, progress):
	if get_tree().is_network_server():
		var progressBar = progress.get_progress_bar()
		generator.connect("progress_max_value_changed", progressBar, "set_max")
		generator.connect("progress_value_changed", progressBar, "set_value")
		thread_load_map = Thread.new()
		var args = {
				path = path,
				is_gen = is_gen,
				progress = progress
			}
		thread_load_map.start(self, "async_load_map", args, 2)
	else:
		read_map("res://Src/default_maze.tres", progress)
		map_ready()
		
func async_load_map(args):
	if not args.is_gen:
		read_map(args["path"], args.progress)
	else:
		gen_map(args.progress)
	call_deferred("load_map_done")

func load_map_done():
	thread_load_map.wait_to_finish()
	map_ready()

func map_ready():
	if get_tree().is_network_server():
		rpc("reload_map", map, exit_pos, spawn_positions)
		material.set_light_mode(0) # Normal mode
	setup()
	emit_signal("maze_generated")

func setup():
	clear_map()
	draw_map(map)
	$Paths.init(map, exit_pos)

func clear_map():
	clear()
	fix_invalid_tiles()
	$Paths.clear()
	$Paths.fix_invalid_tiles() 

func gen_map(progress):
	map = generator.generate(MazeGenSettings.get_settings())
	height = map.size()
	width = map[0].size()
	
	for i in range(map.size()):
		for j in range(map[0].size()):
			inspect_cell(i, j)

func read_map(path, progress):
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

func add_spawn_pos(pos):
	spawn_positions.append(pos)

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
				items_by_position[item.position] = item

# Vectro2(from) with normal coordinate (i, j)
remotesync func draw_path(from, steps = -1):
	$Paths.draw(from, steps)

func set_map(map_, exit_pos_, spawn_pos_):
	map = map_
	exit_pos = exit_pos_
	spawn_positions = spawn_pos_
	setup()

func get_next_spawn_position():
	var pos = spawn_positions[player_in_game]
	player_in_game += 1
	return pos
