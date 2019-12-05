extends Control

func set_max(value):
	$ProgressBar.max_value = value
	$ProgressBar.value = 0
	
func set_value(val):
	$ProgressBar.value = val
	
func set_message(text):
	$ProgressMessage.text = text
	
func get_progress_bar():
	return $progressBar
	
func get_progress_message():
	return $ProgressMessage

