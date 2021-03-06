extends Area2D

class_name lion

signal hit_lion()

const ITEM_NAME = "lion"

var connected_body

func init_shape(up, right, down, left):
	print("shape ", up, " ", right, " ", down, " ", left)
	if up == "#" and right == "#":
		$UR.disabled = true
	if right == "#" and down == "#":
		$DR.disabled = true
	if down == "#" and left == "#":
		$DL.disabled = true
	if left == "#" and up == "#":
		$UL.disabled = true

func _on_Lion_body_entered(body):
	if body.has_method("get_next_enemy_task"):
		if body.connect("kill", self, "slot_kill") == 0:
			connected_body = body
		dell_shape()
		body.settings.stuck = true
		if get_tree().is_network_server():
			var id = 0
			# id????
			body.rpc("hit_lion", body.get_next_enemy_task(1))
		else:
			body.synchronize(body.position)

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
	
func dell_shape():
	$UL.queue_free()
	$ML.queue_free()
	$DL.queue_free()
	$UM.queue_free()
	$MM.queue_free()
	$DM.queue_free()
	$UR.queue_free()
	$MR.queue_free()
	$DR.queue_free()