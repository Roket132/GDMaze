extends Node

var free_places_number = 4

var registrated_players = {}  # in format login:players_info

var players_on_server = {}

#  reg_player
func registration_player(_name, _password, _id):
	registrated_players[_name] = {"password" :_password}
	free_places_number -= 1
	let_player_in(_name, _id)

func player_joined(_name, _password, _id):
	if players_on_server.has(_name):
		gamestate.rpc_id(_id, "remote_end_game")

	if free_places_number <= 0:
		gamestate.rpc_id(_id, "remote_end_game")
	elif registrated_players.has(_name):
		let_player_in(_name, _id)
	else:
		registration_player(_name, _password, _id)

func player_exit(_name):
	players_on_server.erase(_name)

func let_player_in(_name, _id):
	players_on_server[_name] = {"id" : _id}