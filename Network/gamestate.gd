extends Node

const DEFAULT_PORT = 10567 # Default game port

const MAX_PEERS = 4 # Max number of players

var game_started = false
var player_name = "Host" # Name for my player
var progress = null  #  ref to progressBar from Lobby, init in Lobby

var world = null
var spectator = null

var players_name = {}  # Names for remote players in id:name format
var players = {}  # in id:pl_ref format

remote var loaded_players_settings = {}  # players which was loaded and wait self user

remote var settings  # forWhat? FIXME

# Signals to let lobby GUI know what's going on
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

# Callback from SceneTree
func _player_connected(_id):
	pass

# Callback from SceneTree
func _player_disconnected(id):
	if get_tree().is_network_server():
		# TODO
		pass

# Callback from SceneTree, only for clients (not server)
func _connected_ok():
	rpc_id(1, "register_player", get_tree().get_network_unique_id(), player_name)
	emit_signal("connection_succeeded")

# Callback from SceneTree, only for clients (not server)
func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()

# Callback from SceneTree, only for clients (not server)
func _connected_fail():
	get_tree().set_network_peer(null) # Removeset_wo peer
	emit_signal("connection_failed")

# called on server by connected player
remote func register_player(id, new_player_name):
	rpc_id(id, "add_new_player", 1, player_name)
	for p_id in players_name: 
		rpc_id(id, "add_new_player", p_id, players_name[p_id])
		rpc_id(p_id, "add_new_player", id, new_player_name)
	add_new_player(id, new_player_name)
	
	if game_started:
		rset("loaded_players_settings", loaded_players_settings)
		remote_start_late(id, new_player_name)

remotesync func add_new_player(id, new_player_name):
	players_name[id] = new_player_name
	emit_signal("player_list_changed")

remote func unregister_player(id):
	players_name.erase(id)
	emit_signal("player_list_changed")

func host_game():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)

func join_game(ip, new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

func get_player_list():
	return players_name.values()

func get_player_name():
	return player_name

func start_game():
	assert(get_tree().is_network_server())
	
	game_started = true
	
	world = load("res://World/World.tscn").instance()
	get_tree().get_root().add_child(world)
	world.visible = false
	world.init(GameSettings.get_maze_path(), GameSettings.get_maze_gen(), progress)
	
	world.connect("maze_generated", self, "continue_start_game")

func continue_start_game():
	load_players()
	load_spectator()
	world.visible = true
	get_tree().get_root().get_node("MainMenu").queue_free()
	
	end_start_game()

func end_start_game():
	UsingItemsLambdas.players_by_id = players
	for p_id in players:
		remote_start(p_id)

func load_spectator():
	spectator = load("res://Player/Spectator.tscn").instance()
	spectator.set_map_size(world.height, world.width)
	print(players)
	for pl in players:
		spectator.add_player(players[pl])
	world.add_child(spectator)

func load_players():
	for p_id in players_name:
		create_player(p_id)

func create_player(p_id):
	var player = load("res://Player/Player.tscn").instance()
	var name = player_name if p_id == get_tree().get_network_unique_id() else players_name[p_id]
	var spawn_pos
	
	if loaded_players_settings.has(name):
		var settings = loaded_players_settings[name]
		spawn_pos = Vector2(settings.position_x, settings.position_y)
		player.set_settings(settings.settings)
		player.set_complited_tasks(settings["complited_tasks"].enemy, settings["complited_tasks"].arrow)
	else:
		spawn_pos = world.get_next_spawn_position()
	
	players[p_id] = player
	player.setup(world, p_id, name, spawn_pos)
	player.set_network_master(p_id)

	world.add_child(player)

func remote_start(id, late = false):
	rpc_id(id, "remote_create_game", world.map, world.paths_map, world.exit_pos, world.spawn_positions, players_name)
	
func remote_start_late(id, _name):
	rpc_id(id, "remote_create_game", world.map, world.paths_map, world.exit_pos, world.spawn_positions, players_name)
	for p_id in players_name:
		if p_id != id:
			rpc_id(p_id, "remote_add_player", id)
	create_player(id)
	
	spectator.add_player(players[id])
	UsingItemsLambdas.players_by_id = players

remote func remote_create_game(map_, paths_map_, exit_pos_, spawn_pos_, pls_name):
	world = load("res://World/World.tscn").instance()
	world.set_map(map_, paths_map_, exit_pos_, spawn_pos_)
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("MainMenu").queue_free()
	
	players_name = pls_name
	
	load_players()

remote func remote_add_player(p_id):
	create_player(p_id)

func get_game_mode():
	return "SPECTATOR" if get_tree().is_network_server() else "PLAYER"

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func save_game():
	var save_game = File.new()
	save_game.open("res://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game(path):
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.save"):
		return
	
	game_started = true
	host_game()
	
	world = load("res://World/World.tscn").instance()
	get_tree().get_root().add_child(world)
	
	save_game.open("res://savegame.save", File.READ)
	while not save_game.eof_reached():
		var line = parse_json(save_game.get_line())
		if line == null:
			break
		
		GameSettings.load_settings(line["gamesettings"])
		TasksArchives.loaded_enemy_tasks = line["tasksArchives"]["enemy"]
		TasksArchives.loaded_arrow_tasks = line["tasksArchives"]["arrow"]
		
		var spawn_pos = []
		for pos in line["spawn_positions"]:
			spawn_pos.append(Vector2(pos.position_x, pos.position_y))
		world.set_map(line["map"], line["paths_map"], Vector2(line["exit_x"], line["exit_y"]), spawn_pos)
		
		for pl in line["players"]:
			loaded_players_settings[pl] = line["players"][pl]
		
	save_game.close()
	
	world.current_free_pos = gamestate.loaded_players_settings.size()
	
	load_spectator()
	get_tree().get_root().get_node("MainMenu").queue_free()


func end_game():
	game_started = false
	
	for pl in players:
		players[pl].queue_free()
	
	if spectator != null:
		spectator.queue_free()
		
	if world != null:
		world.queue_free()

	emit_signal("game_ended")
	players_name.clear()
	players.clear()
	loaded_players_settings.clear()
	get_tree().set_network_peer(null) # End networking
	
	get_tree().get_root().add_child(preload("res://MainMenu.tscn").instance())

