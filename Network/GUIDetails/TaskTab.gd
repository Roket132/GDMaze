extends Tabs

func _ready():
	$VBoxContainer/Label.text = "Выберите все файлы, которые будут использоваться для " + name + " задач"



func _on_Add_pressed():
	$FileDialog.show()


func _on_Dell_pressed():
	var selected_items = $VBoxContainer/ScrollContainer/Files.get_selected_items()
	var cnt = 0
	for item in selected_items:
		$VBoxContainer/ScrollContainer/Files.remove_item(item - cnt)
		cnt += 1

func _on_FileDialog_files_selected(paths):
	for p in paths:
		$VBoxContainer/ScrollContainer/Files.add_item(p)
	var Files = $VBoxContainer/ScrollContainer/Files
	Files.sort_items_by_text()
	var deleted = 0
	for i in range(1, $VBoxContainer/ScrollContainer/Files.get_item_count()):
		var idx = i - deleted
		if Files.get_item_text(idx - 1) == Files.get_item_text(idx):
			Files.remove_item(idx)
			deleted += 1
