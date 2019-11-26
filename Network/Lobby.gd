extends Control

#export (Script) var gamestate

func _ready():
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")

func _on_Host_pressed():
	if $Connect/NameEdit.text == "":
		$Connect/Error.text = "Invalid name!"
		return
	
	$Connect.hide()
	$Players.show()
	$Connect/Error.text = ""
	
	var player_name = $Connect/NameEdit.text
	gamestate.host_game(player_name)
	refresh_lobby()

func _on_Join_pressed():
	if $Connect/NameEdit.text == "":
		$Connect/Error.text = "Invalid name!"
		return
		
	var ip = $Connect/IPEdit.text
	if not ip.is_valid_ip_address():
		$Connect/Error.text = "Invalid IPv4 address!"
		return
		
	$Connect/Error.text = ""
	$Connect/Host.disabled = true
	$Connect/Join.disabled = true
	
	var player_name = $Connect/NameEdit.text
	gamestate.join_game(ip, player_name)
	

func _on_connection_success():
	get_node("Connect").hide()
	get_node("Players").show()

func _on_connection_failed():
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false
	$Connect/Error.set_text("Connection failed.")

func _on_game_ended():
	show()
	$Connect.show()
	$Players.hide()
	$Connect/Host.disabled = false

func _on_game_error(errtxt):
	get_node("err").dialog_text = errtxt
	get_node("err").popup_centered_minsize()

func refresh_lobby():
	var players = gamestate.get_player_list()
	players.sort()
	$Players/ItemList.clear()
	$Players/ItemList.add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		$Players/ItemList.add_item(p)
		
	$Players/Start.disabled = not get_tree().is_network_server()

func _on_Start_pressed():
	gamestate.begin_game()
