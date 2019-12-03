extends Control

var cur_task

func set_task(task):
	$TextureRect/Text.text = "	\"" + task["name"] + "\"\n\n" + task["task"]
	cur_task = task

func _ready():
	$TextureRect/VBoxContainer/Cancel.text = "Удалить\nстрелку"


func _on_Answer_pressed():
	UsingItemsLambdas.arrow_done()
	hide()


func _on_Cancel_pressed():
	UsingItemsLambdas.arrow_delete()
	hide()
