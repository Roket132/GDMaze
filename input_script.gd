extends Node

func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())