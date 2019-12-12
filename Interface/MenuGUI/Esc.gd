extends Panel

func _input(event):
	if event.is_action_pressed("escape"):
		visible = !visible


func _on_Continue_pressed():
	hide()


func _on_Exit_pressed():
	gamestate.end_game()
