extends Node

var enemy_archives = {}
var cur_enemy_task = {}

var arrow_archives = {}
var cur_arrow_task = {}

# call only on server
func create_for_player(player):
	var enemy_archive = load("res://bin/GDTaskBridge.gdns").new()
	var arrow_archive = load("res://bin/GDTaskBridge.gdns").new()
	# enemy files
	for file in GlobalSettings.get_enemy_taskFiles():
		enemy_archive.add_file(file)
	
	# arrow files
	for file in GlobalSettings.get_arrow_taskFiles():
		arrow_archive.add_file(file)
		
	enemy_archives[player] = enemy_archive
	arrow_archives[player] = arrow_archive

func get_next_enemy_task(player, lvl):
	var archive = enemy_archives[player]
	var task = archive.get_next_task(lvl)
	cur_enemy_task[player] = task
	return task
	
func get_next_arrow_task(player, lvl):
	var archive = arrow_archives[player]
	var task = archive.get_next_task(lvl)
	cur_arrow_task[player] = task
	return task
	
func check_enemy_answer(player, answer):
	return check_answer(player, answer, cur_enemy_task[player]["answers"])
	
func check_arrow_answer(player, answer):
	return check_answer(player, answer, cur_arrow_task[player]["answers"])
	
func check_answer(player, answer, answers):
	for ans in answers:
		if answer == ans:
			return true
	return false