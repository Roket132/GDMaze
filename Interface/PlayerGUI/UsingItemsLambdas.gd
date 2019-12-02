extends Node

var pl_ref = null

signal del_item(name)

var lambdas_dict = {
	torch = funcref(self, "torch"),
	arrow = funcref(self, "arrow")
}

func torch():
	print("use torch")
	
func arrow():
	var pos = pl_ref.position
	var from = Vector2((pos.y - pl_ref.DIFF) / pl_ref.BLOCK_SIZE, (pos.x - pl_ref.DIFF) / pl_ref.BLOCK_SIZE)
	
	emit_signal("del_item", "arrow")
	pl_ref.world.rpc("draw_path", from, 5)
