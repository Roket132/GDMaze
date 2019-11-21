extends Area2D

class_name torch

signal hit_torch

func _on_Torch_body_entered(body):
	body.rpc("hit_torch")
	queue_free()