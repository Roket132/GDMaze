extends Camera2D

var mouse_captured = false

var focus_pawn = null

func _ready():
	#OS.set_window_size(Vector2(1920, 1080))
	OS.set_window_fullscreen(true)
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
	if focus_pawn != null:
		position = focus_pawn.position

func set_map_size(h, w):
	limit_right = (w + 1) * 64 + 32
	limit_bottom = (h + 1) * 64 + 32
	pass
	
func _focus_on_pos(pawn):
	set_offset(Vector2(0, -1)) # some kinde of magic with offset :|
	focus_pawn = pawn
	
func add_player(pl):
	var info = load("res://Interface/SpectatorGUI/PlayerInfo.tscn").instance()
	info.set_player(pl)
	info.connect("focus", self, "_focus_on_pos")
	pl.connect("clicked", self, "_focus_on_pos")
	$CanvasLayer/PlayersPanel/Panel/VScrollBar/VBoxContainer.add_child(info)