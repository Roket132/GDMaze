extends Node

var lambdas_dict = {
	torch = funcref(self, "torch"),
	arrow = funcref(self, "arrow")
}

func torch():
	print("use torch")
	
func arrow():
	print("arrow")
