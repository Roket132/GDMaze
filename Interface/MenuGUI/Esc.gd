extends Panel

func _input(event):
	if event.is_action_pressed("escape") and not $Save.saving == true:
		visible = !visible
		$Save.visible = false


func _on_Continue_pressed():
	hide()


func _on_Save_pressed():
	$Save.show()


func _on_Exit_pressed():
	gamestate.end_game()

