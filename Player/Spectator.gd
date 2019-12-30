extends Camera2D

var mouse_captured = false

var focus_pawn = null

var players = []

var infos = {}  # in format player:info

func _ready():
	#OS.set_window_fullscreen(true)
	set_offset(Vector2(0, -1))
	make_current()

func _input(event):
	if event.is_action_pressed("cam_drag"):
		mouse_captured = true
		focus_pawn = null
	elif event.is_action_released("cam_drag"):
		mouse_captured = false
	if mouse_captured && event is InputEventMouseMotion:
		set_offset(get_offset() - event.relative)

func _physics_process(delta):
	if focus_pawn != null and focus_pawn.get_ref():
		position = focus_pawn.get_ref().position

func set_map_size(h, w):
	limit_right = (w + 1) * 64 + 32
	limit_bottom = (h + 1) * 64 + 32
	
func _focus_on_pos(pawn):
	set_offset(Vector2(0, -1)) # some kinde of magic with offset :|
	focus_pawn = weakref(pawn);
	
func add_player(pl):
	players.append(pl)
	
	var info = load("res://Interface/SpectatorGUI/PlayerInfo.tscn").instance()
	infos[pl] = info
	info.set_player(pl)
	info.connect("focus", self, "_focus_on_pos")
	pl.connect("clicked", self, "_focus_on_pos")
	
	pl.connect("increase_score", info, "increase_score")
	
	# init score
	info.increase_score(pl.settings["score"])
	
	$CanvasLayer/PlayersPanel/Panel/VScrollBar/VBoxContainer.add_child(info)


func del_player(pl_ref):
	var pos = 0
	for player in players:
		if player == pl_ref:
			break
		pos += 1
	
	players.erase(pos)
	infos[pl_ref].queue_free()
