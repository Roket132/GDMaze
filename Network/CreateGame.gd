extends Control

func _on_Choice_pressed():
	$FileDialog.show()

func _on_FileDialog_file_selected(path):
	$Panel/BlockName/Path.text = path
