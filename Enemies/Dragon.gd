extends Area2D

class_name dragon

signal hit_dragon

const ITEM_NAME = "dragon"

func _on_Dragon_body_entered(body):
	if get_tree().is_network_server():
		var id = 0
		# id?????
		#body.rpc("hit_lion", "Привет, я должа быть задачей)))")
	
func _get_texture():
	return $Sprite.get_texture()