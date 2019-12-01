extends Control

func set_task(task):
	$TextureRect/Task/Label.text = "	" + task["name"] + "\n\n" + task["task"]

func _on_GoAnswer_pressed():
	$TextureRect/Task.hide()
	$TextureRect/Answer.show()


func _on_Back_pressed():
	$TextureRect/Task.show()
	$TextureRect/Answer.hide()


func _on_Send_pressed():
	Receiver.rpc("answer", $TextureRect/Answer/Label.text)
