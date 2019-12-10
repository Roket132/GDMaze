extends Node

# Default game port
const DEFAULT_PORT = 10567

# Max number of players
const MAX_PEERS = 4

# Name for my player
var player_name = "Host"

var world = null
var progress = null

var players_name = {}  # Names for remote players in id:name format
var players = {}  # in id:pl_ref format

# Save spawn_pos for players reloading
var reload_spawn_points

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

remotesync func add_new_player(id, new_player_name):
	players_name[id] = new_player_name
	emit_signal("player_list_changed")

remote func unregister_player(id):
	players_name.erase(id)
	emit_signal("player_list_changed")

remote func post_start_game():
	pass

var players_ready = []

remote func ready_to_start(id):
	assert(get_tree().is_network_server())

	if not id in players_ready:
		players_ready.append(id)

	if players_ready.size() == players_name.size():
		for p_id in players_name:
			rpc_id(p_id, "post_start_game")
		post_start_game()

func host_game():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	print("created")
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
	
	world = load("res://Map/Map.tscn").instance()
	get_tree().get_root().add_child(world)
	world.visible = false
	world.init(GlobalSettings.get_maze_path(), GlobalSettings.get_maze_gen(), progress)
	
	world.connect("maze_generated", self, "continue_start_game")

func continue_start_game():
	load_players()
	load_spectator()
	world.visible = true
	get_tree().get_root().get_node("MainMenu").queue_free()
	
	ending_start_game()

func ending_start_game():
	UsingItemsLambdas.players_by_id = players
	for p_id in players:
		remote_start(p_id)

func load_spectator():
	var spectator = load("res://Player/Spectator.tscn").instance()
	spectator.set_map_size(world.height, world.width)
	print(players)
	for pl in players:
		spectator.add_player(players[pl])
	world.add_child(spectator)

func load_players():
	var player_scene = preload("res://Player/Player.tscn")
	for p_id in players_name:
		var player = player_scene.instance()
		var name = player_name if p_id == get_tree().get_network_unique_id() else players_name[p_id]
		var spawn_pos = world.get_next_spawn_position()
		players[p_id] = player
		
		player.setup(world, p_id, name, spawn_pos)
		player.set_network_master(p_id)
		
		player.scale = Vector2(0.5, 0.5)
		world.add_child(player)

func remote_start(id):
	rpc_id(id, "remote_create_game", world.map, world.exit_pos, world.spawn_positions, players_name)

remote func remote_create_game(map, exit_pos_, spawn_pos_, pls_name):
	world = load("res://Map/Map.tscn").instance()
	world.set_map(map, exit_pos_, spawn_pos_)
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("MainMenu").queue_free()
	
	players_name = pls_name
	
	load_players()
	
remote func remote_add_player(pl):
	pass

func end_game():
	if has_node("/root/world"): # Game is in progress
		# End it
		get_node("/root/world").queue_free()

	emit_signal("game_ended")
	players_name.clear()
	get_tree().set_network_peer(null) # End networking

func get_game_mode():
	return "SPECTATOR" if get_tree().is_network_server() else "PLAYER"

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
