extends Node

var _value = {
	torch = 5,
	lion = 50,
	dragon = 100,
	arrow = 75,
	exit = 1000
}

var exit_multiplier = 4  #instead 4 needs cnt of players

func get_value(type):
	if type == "exit":
		var res = _value[type] * exit_multiplier
		exit_multiplier -= 1
		return res
	else:
		return _value[type]
		