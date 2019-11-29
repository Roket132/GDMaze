extends Area2D

class_name lion

signal hit_lion

const ITEM_NAME = "lion"

func _on_Lion_body_entered(body):
	if get_tree().is_network_server():
		var id = 0
		# id?????
		body.rpc("hit_lion", "Привет, я должа быть задачей)))")
	
func _get_texture():
	return $Sprite.get_texture()