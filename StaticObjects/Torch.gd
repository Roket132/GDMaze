extends Area2D

class_name torch

signal hit_torch

const ITEM_NAME = "torch"

func _on_Torch_body_entered(body):
	if get_tree().is_network_server():
		# to all
		body.rpc("hit_torch")
		gamestate.world.rpc("hit_torch", position)
		# to master
		body.rpc("add_item" , ITEM_NAME)
	queue_free()
	
func _get_texture():
	return $Sprite.get_texture()