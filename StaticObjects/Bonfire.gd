extends Area2D

class_name bonfire

signal hit_bonfire

const ITEM_NAME = "bonfire"

func _on_Bonfire_body_entered(body):
	body.rpc("hit_bonfire", self)
	
func _get_texture():
	return $AnimatedSprite.frames.get_frame("fire", 0)