extends Node

# only for players
var pl_ref = null
# only for server
var players_by_id = {}

signal del_item(name)

var lambdas_dict = {
	torch = funcref(self, "torch"),
	arrow = funcref(self, "arrow")
}

func torch():
	print("use torch")

var arrow_task_scene = preload("res://Interface/DialogGUI/ArrowDialog.tscn")
var cur_arrow_task = null
	
remote func get_arrow_task(id):
	rpc_id(id, "set_arrow_task", TasksArchives.get_next_arrow_task(players_by_id[id], 1))

remote func set_arrow_task(task):
	cur_arrow_task = arrow_task_scene.instance()
	cur_arrow_task = task
	pl_ref.set_arrow_task(task)

func arrow():
	if cur_arrow_task != null:
		return
	else:
		print(pl_ref)
		rpc_id(1, "get_arrow_task", get_tree().get_network_unique_id())
		
func arrow_delete():
	cur_arrow_task = null		
	emit_signal("del_item", "arrow")

func arrow_done():	
	cur_arrow_task = null

	var pos = pl_ref.position
	var from = Vector2((pos.y - pl_ref.DIFF) / pl_ref.BLOCK_SIZE, (pos.x - pl_ref.DIFF) / pl_ref.BLOCK_SIZE)
	emit_signal("del_item", "arrow")
	pl_ref.world.rpc("draw_path", from, 5)
