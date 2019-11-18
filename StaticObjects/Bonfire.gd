extends Area2D

signal hit_bonfire

func _on_Bonfire_body_entered(body):
	emit_signal("hit_bonfire")
