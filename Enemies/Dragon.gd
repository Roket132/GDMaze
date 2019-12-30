extends Area2D

class_name dragon

signal hit_dragon

const ITEM_NAME = "dragon"

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

func _on_Dragon_body_entered(body):
	if body.has_method("get_next_enemy_task"):
		if body.connect("kill", self, "slot_kill") == 0:
			connected_body = body
		body.settings.stuck = true
		dell_shape()
		
		if get_tree().is_network_server():
			var id = 0
			# id????
			if body.has_method("get_next_enemy_task"):
				body.rpc("hit_dragon", body.get_next_enemy_task(2))
		else:
			body.synchronize(body.position)
	
func _get_texture():
	return $Sprite.get_texture()
	
func slot_kill():
	#rpc("kill")
	kill()

func kill():
	connected_body.disconnect("kill", self, "slot_kill")
	$Sprite.texture = load("res://Enemies/sprites/dragon_off.png")
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