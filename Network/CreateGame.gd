extends Control

func _on_Choice_pressed():
	$FileDialog.show()

func _on_FileDialog_file_selected(path):
	$Panel/VBoxContainer/NameBlock/PathContainer/Path.text = path

func get_maze_path():
	return $Panel/VBoxContainer/NameBlock/PathContainer/Path.text
	
func get_enemy_taskFiles_list():
	return $Panel/VBoxContainer/MazeBlock/TabContainer/Enemy.get_files()

func get_arrow_taskFiles_list():
	return $Panel/VBoxContainer/MazeBlock/TabContainer/Arrow.get_files()
	
func get_error():
	return $Panel/VBoxContainer/NameBlock/Error

func set_error(text):
	$Panel/VBoxContainer/NameBlock/Error.text = text

var generate

func is_generate():
	return generate

func _on_GenCheckBox_pressed():
	$Panel/VBoxContainer/NameBlock/Choice.disabled = not $Panel/VBoxContainer/NameBlock/Choice.disabled
	if $Panel/VBoxContainer/NameBlock/Choice.disabled:
		$Panel/VBoxContainer/NameBlock/PathContainer/Path.text = "Лабиринт будет сгенерирован!"
		generate = true
	else:
		generate = false
