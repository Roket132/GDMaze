extends Node

var enemy_archives = {}

var cur_enemy_task = {}

func create_for_player(player):
	var enemy_archive = load("res://bin/GDTaskBridge.gdns").new()
	enemy_archive.add_file("C:/Users/Dmitry/Desktop/GODOT PICTURE/enemyTasks.txt")
	enemy_archives[player] = enemy_archive

func get_next_enemy_task(player, lvl):
	var archive = enemy_archives[player]
	var task = archive.get_next_task(lvl)
	cur_enemy_task[player] = task
	return task
