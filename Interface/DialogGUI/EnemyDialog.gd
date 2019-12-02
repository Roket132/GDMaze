extends Control

signal correct_answer()

var _task

func set_task(task):
	$TextureRect/Task/Label.text = "	" + task["name"] + "\n\n" + task["task"]
	_task = task

func _on_GoAnswer_pressed():
	$TextureRect/Task.hide()
	$TextureRect/Answer.show()

func _on_Back_pressed():
	$TextureRect/Task.show()
	$TextureRect/Answer.hide()

func _on_Send_pressed():
	var answer = $TextureRect/Answer/Label.text
	if TasksArchives.check_answer_for_task(answer, _task):
		emit_signal("correct_answer")
	