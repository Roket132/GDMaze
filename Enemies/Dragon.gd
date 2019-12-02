extends Area2D

class_name dragon

signal hit_dragon

const ITEM_NAME = "dragon"

var connected_body

func _on_Dragon_body_entered(body):
	if body.connect("kill", self, "slot_kill") == 0:
		connected_body = body
		
	if get_tree().is_network_server():
		var id = 0
		# id????
		if body.has_method("get_next_enemy_task"):
			body.rpc("hit_dragon", body.get_next_enemy_task(2))
	
func _get_texture():
	return $Sprite.get_texture()
	
func slot_kill():
	rpc("kill")

remotesync func kill():
	connected_body.disconnect("kill", self, "slot_kill")
	$CollisionShape2D.queue_free()
	$Sprite.texture = load("res://Enemies/sprites/dragon_off.png")