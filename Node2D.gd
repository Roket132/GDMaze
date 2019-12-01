extends Node2D

func _ready():
	var cpp = load("res://bin/GDTaskBridge.gdns").new()
	cpp.init_acrhive("C:/Users/Dmitry/Desktop/GODOT PICTURE/tasks.txt")