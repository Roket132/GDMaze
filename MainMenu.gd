extends Control


func _on_Join_pressed():
	$Menus/Lobby.start_game()

func _on_Host_pressed():
	$Menus/Lobby.create_game()


func _on_MainMenu_hide():
	$Background.hide()
	$Menus.hide()
