extends Control

#export (Script) var gamestate

func _ready():
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	
	$CreateGame/Panel/Back.connect("pressed", self, "to_main_menu")
	$StartGame/Panel/Back.connect("pressed", self, "to_main_menu")
	$Players/Exit.connect("pressed", self, "to_main_menu")
	
	$CreateGame/Panel/CreateGame.connect("pressed", self, "_on_Host_pressed")
	$StartGame/Panel/StartGame.connect("pressed", self, "_on_Join_pressed")


func create_game():
	$CreateGame.show()
	
func start_game():
	$StartGame.show()

var thread_load_game

func _on_Host_pressed():
	if $CreateGame.get_maze_path() == "":
		$Connect/Error.text = "Invalid path!"
		return
	
	$CreateGame.hide()
	$Players.show()
	$CreateGame.set_error("")
	
	GameSettings.set_maze_gen($CreateGame.is_generate())
	GameSettings.set_maze_path($CreateGame.get_maze_path())
	GameSettings.set_enemy_taskFiles($CreateGame.get_enemy_taskFiles_list())
	GameSettings.set_arrow_taskFiles($CreateGame.get_arrow_taskFiles_list())
	
	gamestate.progress = $Players/Progress
		
	gamestate.host_game()
	refresh_lobby()

func _on_Join_pressed():
	if $StartGame/Panel/Name.text == "":
		$StartGame/Panel/Error.text = "Invalid name!"
		return
		
	var ip = $StartGame/Panel/IP.text
	if not ip.is_valid_ip_address():
		$StartGame/Panel/Error.text = "Invalid IPv4 address!"
		return
	
	$StartGame/Panel/Error.text = ""
	$StartGame/Panel/StartGame.disabled = true
	$StartGame/Panel/Back.disabled = true
	
	var player_name = $StartGame/Panel/Name.text
	gamestate.join_game(ip, player_name)


func _on_connection_success():
	get_node("StartGame").hide()
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
	gamestate.start_game()

func to_main_menu():
	$Players.visible = false
	$CreateGame.visible = false
	$StartGame.visible = false

