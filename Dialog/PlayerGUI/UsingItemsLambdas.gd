extends Node

var pl_ref = null

var lambdas_dict = {
	torch = funcref(self, "torch"),
	arrow = funcref(self, "arrow")
}

func torch():
	print("use torch")
	
func arrow():
	var pos = pl_ref.position
	var from = Vector2((pos.y - pl_ref.DIFF) / pl_ref.BLOCK_SIZE, (pos.x - pl_ref.DIFF) / pl_ref.BLOCK_SIZE)
	print("from = ", from)
	pl_ref.world.rpc("draw_path", from, 5)
