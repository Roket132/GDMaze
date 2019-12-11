extends Area2D

class_name arrow

signal hit_arrow

const ITEM_NAME = "arrow"

func _on_Arrow_body_entered(body):
	if get_tree().is_network_server():
		# to all
		body.rpc("hit_arrow")
		# to master
		body.rpc("add_item" , ITEM_NAME)
	queue_free()
	
func _get_texture():
	return $Sprite.get_texture()