extends Camera2D

var mouse_captured = false

var focus_pawn = null

func _ready():
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
	limit_right = (w + 1) * 64
	limit_bottom = (h + 1) * 64
	
func _focus_on_pos(pawn):
	set_offset(Vector2(0, 0)) # some kinde of magic with offset :|
	focus_pawn = pawn