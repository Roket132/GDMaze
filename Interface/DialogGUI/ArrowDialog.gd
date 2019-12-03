extends Control

var cur_task
var mode = "task"

func set_task(task):
	$TextureRect/Text.text = "	\"" + task["name"] + "\"\n\n" + task["task"]
	cur_task = task

func _ready():
	$TextureRect/VBoxContainer/Cancel.text = "Удалить\nстрелку"

func _on_Answer_pressed():
	if mode == "task":
		$TextureRect/Back.show()
		$TextureRect/Text.text = ""
		$TextureRect/VBoxContainer/Answer.text = "Отправить!"
		mode = "answer"
	else:
		if TasksArchives.check_answer_for_task($TextureRect/Text.text, cur_task) == true:
			UsingItemsLambdas.arrow_done()
			_on_Back_pressed()
			$TextureRect/Text.text = ""
			hide()

func _on_Cancel_pressed():
	UsingItemsLambdas.arrow_delete()
	hide()

func _on_Back_pressed():
	$TextureRect/Back.hide()
	$TextureRect/Text.text = cur_task.task
	$TextureRect/VBoxContainer/Answer.text = "Ответить!"
	mode = "task"
