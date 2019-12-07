extends Node

# Generations settings

var _size = Vector2(50, 50)

func get_size():
	return _size

func set_size(sz):
	_size = sz

var _walls = 35

func get_walls():
	return _walls
	
func set_walls(cnt):
	_walls = cnt

var _torch_r = 40

func get_torch_radius():
	return _torch_r
	
func set_torch_radius(cnt):
	_torch_r = cnt

var _bonfire_r = 25

func get_bonfire_radius():
	return _bonfire_r
	
func set_bonfire_radius(cnt):
	_bonfire_r = cnt

var _arrow_r = 25

func get_arrow_radius():
	return _arrow_r
	
func set_arrow_radius(cnt):
	_arrow_r = cnt

var _chest_r = 22

func get_chest_radius():
	return _chest_r
	
func set_chest_radius(cnt):
	_chest_r = cnt

var _lvl1_r = 25
var _lvl1_limit = 80

func get_lvl1():
	return { radius = _lvl1_r, limit = _lvl1_limit }

func set_lvl1(radius, limit):
	_lvl1_r = radius
	_lvl1_limit = limit

var _lvl2_r = 35
var _lvl2_limit = 40

func get_lvl2():
	return { radius = _lvl2_r, limit = _lvl2_limit }
	
func set_lvl2(radius, limit):
	_lvl2_r = radius
	_lvl2_limit = limit
	
func get_settings():
	return [_size.x, _size.y, _walls, _torch_r, _bonfire_r, _arrow_r, _chest_r, _lvl1_r, _lvl1_limit, 
			_lvl2_r, _lvl2_limit]
	