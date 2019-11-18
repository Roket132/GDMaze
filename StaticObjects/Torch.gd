extends Area2D

signal hit_torch

func _on_Torch_body_entered(body):
	emit_signal("hit_torch")
	queue_free()
