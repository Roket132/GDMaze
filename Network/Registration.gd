extends Node

var registrated_players = {}  # in format login:player_dictionary

var players_on_server = []

func registration_player(_name):
	registrated_players[_name] = {}
	
func player_joined(_name, _id):
	registrated_players[_name].id = _id
	players_on_server.append(_name)