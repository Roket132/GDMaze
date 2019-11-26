extends Control

func _ready():
	$VBoxContainer/HBoxContainer/Avatar.set_size(Vector2(64, 64))
	$VBoxContainer/HBoxContainer/Name.set_size(Vector2(192, 64))
	
	$VBoxContainer/ScoreBox.set_size(Vector2(256, 35))
	$VBoxContainer/MoneyBox.set_size(Vector2(256, 35))

	$VBoxContainer.set_size(Vector2(256, 135))
	
	set_size(Vector2(256, 135))
	set_margin(MARGIN_TOP, -438)

func set_player(pl):
	$VBoxContainer/HBoxContainer/Avatar/Avatar.texture = pl.settings["texture"]