extends Panel

var SAVE_FOLDER = "res://saves/"

func _ready():
	var files = list_files_in_directory("res://saves")
	
	for file in files:
		$SaveFiles.add_item(file)


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
		
	dir.list_dir_end()
	
	return files


func _on_Cancel_pressed():
	hide()


func _on_SaveFiles_item_selected(index):
	$HBoxContainer2/FileName.text = $SaveFiles.get_item_text(index)

var saving = false
var save_thread
onready var save_progress = $SaveProgress

func _on_Ok_pressed():
	var file = remove_spaces($HBoxContainer2/FileName.text)
	if file == "":
		return
	
	saving = true
	save_thread = Thread.new()
	save_thread.start(self, "_save_in_thread", SAVE_FOLDER + file)


func _save_in_thread(file):
	gamestate.save_game(file)
	
	save_progress.call_deferred("set_max", 10)
	for i in range(11):
		OS.delay_msec(10.0)
		save_progress.call_deferred("set_value", i)
		
	call_deferred("_save_done")

func _save_done():
	save_thread.wait_to_finish()
	save_progress.set_value(0)
	visible = false
	saving = false

func remove_spaces(str_):
	var res_str = ""
	for s in str_:
		if s != " ":
			res_str += s
	return res_str