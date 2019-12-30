extends Area2D

class_name exit

signal hit_exit

const ITEM_NAME = "exit"


var already_out = []

func _on_Exit_body_entered(body):
	if get_tree().is_network_server():
		# to master
		if not body in already_out:
			body.rpc("hit_exit")
			already_out.append(body)
	else:
		body.synchronize(position)
	
func _get_texture():
	return $Sprite.get_texture()