extends Node

var free_places_number = 4

var registrated_players = {}  # in format login:players_info

var players_on_server = {}

#  reg_player
func registration_player(_name, _password, _id):
	pass

func player_joined(_name, _password, _id):
	if free_places_number <= 0:
		gamestate.rpc_id(_id, "end_game")
	elif registrated_players.has(_name):
		let_player_in(_name, _id)
	else:
		registration_player(_name, _password, _id)


func let_player_in(_name, _id):
	players_on_server[_name]["id"] = _id