extends Area2D

class_name exit

signal hit_exit

const ITEM_NAME = "exit"

func _on_Exit_body_entered(body):
	pass
	
func _get_texture():
	return $Sprite.get_texture()