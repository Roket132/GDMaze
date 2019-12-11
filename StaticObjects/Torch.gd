extends Area2D

class_name torch

signal hit_torch

const ITEM_NAME = "torch"

func _on_Torch_body_entered(body):
	if get_tree().is_network_server():
		# to all
		body.rpc("hit_torch")
		# to master
		body.rpc("add_item" , ITEM_NAME, _get_texture().get_load_path())
	queue_free()
	
func _get_texture():
	return $Sprite.get_texture()