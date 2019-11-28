extends Control

signal focus(player)

func _ready():
	$VBoxContainer/HBoxContainer/Avatar.set_size(Vector2(64, 64))
	$VBoxContainer/HBoxContainer/Name.set_size(Vector2(192, 64))
	
	$VBoxContainer/ScoreBox.set_size(Vector2(256, 35))
	$VBoxContainer/MoneyBox.set_size(Vector2(256, 35))

	$VBoxContainer.set_size(Vector2(256, 135))
	
	set_size(Vector2(256, 135))
	set_margin(MARGIN_TOP, -438)

var player = null

func set_player(pl):
	player = pl
	$VBoxContainer/HBoxContainer/Avatar/Avatar.texture = pl.settings["texture"]
	$VBoxContainer/HBoxContainer/Name.text = pl.settings.name

func _on_Avatar_pressed():
	if player != null:
		emit_signal("focus", player)
