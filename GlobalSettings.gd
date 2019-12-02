extends Node

var _enemy_taskFiles_list

var _arrow_taskFiles_list

var _maze

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