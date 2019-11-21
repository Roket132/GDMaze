extends Area2D

class_name bonfire

signal hit_bonfire

func _on_Bonfire_body_entered(body):
	body.rpc("hit_bonfire")
