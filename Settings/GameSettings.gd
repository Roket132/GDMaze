extends Node

var _enemy_taskFiles_list

var _arrow_taskFiles_list

var _maze

# if true maze will be generate
var _IsGen

func set_maze_gen(flag):
	_IsGen = flag
	
func get_maze_gen():
	return _IsGen

func set_maze_path(map):
	_maze = map
	
func get_maze_path():
	return _maze

func set_enemy_taskFiles(enemy):
	_enemy_taskFiles_list = enemy
	
func set_arrow_taskFiles(arrow):
	_arrow_taskFiles_list = arrow
	
func get_arrow_taskFiles():
	return _arrow_taskFiles_list
	
func get_enemy_taskFiles():
	return _enemy_taskFiles_list
	
func save():
	return {
		"enemy" : _enemy_taskFiles_list,
		"arrow" : _arrow_taskFiles_list
		}
		
func load_settings(dict):
	_enemy_taskFiles_list = dict["enemy"]
	_arrow_taskFiles_list = dict["arrow"]