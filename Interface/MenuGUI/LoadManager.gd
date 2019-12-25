extends Panel

var SAVE_FOLDER_PATH = "user://saves/"
var SAVE_FOLDER_NAME = "saves"

func _ready():
	var dir = Directory.new()
	dir.open("user://")
	if not dir.dir_exists(SAVE_FOLDER_NAME):
		dir.make_dir(SAVE_FOLDER_NAME)
	
	var files = list_files_in_directory(SAVE_FOLDER_PATH)
	for file in files:
		$Files.add_item(file)


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


func _on_Ok_pressed():
	var arr = $Files.get_selected_items()
	var file = ""
	if arr.size() != 0:
		file = $Files.get_item_text(arr[0])
	
	if file != "":
		gamestate.load_game(SAVE_FOLDER_PATH + file)


func _on_Cancel_pressed():
	hide()
