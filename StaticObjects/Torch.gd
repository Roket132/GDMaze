extends Area2D

class_name torch

signal hit_torch

var item_name = "torch"

func _on_Torch_body_entered(body):
	if get_tree().is_network_server():
		# to all
		body.rpc("hit_torch", self)
		# to master
		body.rpc("add_item" , item_name, _get_texture().get_load_path())
	queue_free()
	
func _get_texture():
	return $Sprite.get_texture()