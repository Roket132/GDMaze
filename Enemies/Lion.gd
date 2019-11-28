extends Area2D

class_name lion

signal hit_lion

const ITEM_NAME = "lion"

func _on_Lion_body_entered(body):
	pass
	
func _get_texture():
	return $Sprite.get_texture()