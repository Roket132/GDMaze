extends Area2D

class_name lion

signal hit_lion

const ITEM_NAME = "lion"

func _on_Lion_body_entered(body):
	if get_tree().is_network_server():
		var id = 0
		# id????
		if body.has_method("get_next_enemy_task"):
			body.rpc("hit_lion", body.get_next_enemy_task(1))
	
func _get_texture():
	return $Sprite.get_texture()