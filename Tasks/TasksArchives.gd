extends Node

var enemy_archives = {}  # in format pl:archive
var cur_enemy_task = {}  # in format pl:task_dict
var complited_enemy_task = {}  # in format pl:array

var arrow_archives = {}
var cur_arrow_task = {}
var complited_arrow_task = {}

# call only on server
func create_for_player(player, complited_enemy = [], complited_arrow = []):
	var enemy_archive = load("res://bin/GDTaskBridge.gdns").new()
	var arrow_archive = load("res://bin/GDTaskBridge.gdns").new()
	# enemy files
	for file in GameSettings.get_enemy_taskFiles():
		enemy_archive.add_file(file)
	
	# arrow files
	for file in GameSettings.get_arrow_taskFiles():
		arrow_archive.add_file(file)
		
	enemy_archives[player] = enemy_archive
	arrow_archives[player] = arrow_archive
	
	cur_enemy_task[player] = {"name" : "nullptr"}
	cur_arrow_task[player] = {"name" : "nullptr"}
	
	complited_enemy_task[player] = complited_enemy
	complited_arrow_task[player] = complited_arrow
	
	load_task(player)

func set_complited_task(player, enemy, arrow):
	complited_arrow_task[player] = arrow
	complited_enemy_task[player] = enemy

func get_next_enemy_task(player, lvl):
	var archive = enemy_archives[player]
	var task = archive.get_next_task(lvl)
	while task["name"] in complited_enemy_task[player] and task["name"] != "nullptr":
		task = archive.get_next_task(lvl)
	cur_enemy_task[player] = task
	if task.name != "nullptr":
		complited_enemy_task[player].append(task.name)
	return task
	
func get_next_arrow_task(player, lvl):
	var archive = arrow_archives[player]
	var task = archive.get_next_task(lvl)
	while task["name"] in complited_arrow_task[player] and task["name"] != "nullptr":
		task = archive.get_next_task(lvl)
	cur_arrow_task[player] = task
	if task.name != "nullptr":
		complited_arrow_task[player].append(task.name)
	return task
	
func check_enemy_answer(player, answer):
	return check_answer(player, answer, cur_enemy_task[player]["answers"])
	
func check_arrow_answer(player, answer):
	return check_answer(player, answer, cur_arrow_task[player]["answers"])
	
func check_answer(player, answer, answers):
	if cur_enemy_task[player]["name"] == "nullptr":
		return true
	for ans in answers:
		if answer == ans:
			return true
	return false
	
func check_answer_for_task(answer, task):
	if task.name == "nullptr":
		return true
	for ans in task.answers:
		if answer == ans:
			return true
	return false


func save_complited_tasks(player):
	return {
		"enemy" : complited_enemy_task[player],
		"arrow" : complited_arrow_task[player]
		}

func get_all_tasks(files):
	var archive = load("res://bin/GDTaskBridge.gdns").new()
	for file in files:
		archive.add_file(file)
		
	var tasks = []
	for lvl in [1, 2]:
		var task = archive.get_next_task(lvl)
		while task["name"] != "nullptr":
			tasks.append(task)
			task = archive.get_next_task(lvl)
	return tasks

func save():
	return {
		"enemy" : get_all_tasks(GameSettings.get_enemy_taskFiles()),
		"arrow" : get_all_tasks(GameSettings.get_arrow_taskFiles())
		}

var loaded_enemy_tasks = []
var loaded_arrow_tasks = []

func load_task(player):
	for task in loaded_enemy_tasks:
		enemy_archives[player].add_task(task)
	for task in loaded_arrow_tasks:
		arrow_archives[player].add_task(task)

