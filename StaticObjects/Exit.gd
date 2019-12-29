extends Area2D

class_name exit

signal hit_exit

const ITEM_NAME = "exit"

func _on_Exit_body_entered(body):
	if get_tree().is_network_server():
		# to master
		body.rpc("hit_exit")
	
func _get_texture():
	return $Sprite.get_texture()