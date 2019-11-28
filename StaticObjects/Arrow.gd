extends Area2D

class_name arrow

signal hit_arrow

const ITEM_NAME = "arrow"

func _on_Arrow_body_entered(body):
	if get_tree().is_network_server():
		# to all
		body.rpc("hit_arrow", self)
		# to master
		body.rpc("add_item" , ITEM_NAME, _get_texture().get_load_path())
	queue_free()
	
func _get_texture():
	return $Sprite.get_texture()