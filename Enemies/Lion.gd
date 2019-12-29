extends Area2D

class_name lion

signal hit_lion()

const ITEM_NAME = "lion"

var connected_body

func _on_Lion_body_entered(body):
	if body.connect("kill", self, "slot_kill") == 0:
		connected_body = body
	
	if body.has_method("get_next_enemy_task"):
		body.settings.stuck = true
		$CollisionShape2D.queue_free()
		
	if get_tree().is_network_server():
		var id = 0
		# id????
		if body.has_method("get_next_enemy_task"):
			body.rpc("hit_lion", body.get_next_enemy_task(1))
	else:
		body.synchronize(position)
	
func _get_texture():
	return $Sprite.get_texture()
	
func slot_kill():
	#rpc("kill")
	kill()

func kill():
	print("rpc remotesync")
	connected_body.disconnect("kill", self, "slot_kill")
	$Sprite.texture = load("res://Enemies/sprites/lion_dead.png")
	gamestate.world.rpc("kill_enemy", position)