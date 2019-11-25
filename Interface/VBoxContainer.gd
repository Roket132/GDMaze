extends VBoxContainer

func _ready():
	$HBoxContainer/Avatar.set_size(Vector2(64, 64))
	$HBoxContainer/Name.set_size(Vector2(64, 192))
	
	$ScoreBox.set_size(Vector2(35, 256))
	$MoneyBox.set_size(Vector2(35, 256))

	$VBox

