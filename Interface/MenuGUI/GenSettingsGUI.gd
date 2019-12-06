extends Control

var S = MazeGenSettings

func _update():
	S.set_size(Vector2($Panel/MainContainer/VariantsContainer/SizeContainer/HBoxContainer/N_Size.text as int,
	 					$Panel/MainContainer/VariantsContainer/SizeContainer/HBoxContainer/M_Size.text as int))
	
	S.set_walls($Panel/MainContainer/VariantsContainer/WallsContainer/HBoxContainer/Walls.text as int)
	
	S.set_torch_radius($Panel/MainContainer/VariantsContainer/TorchContainer/HBoxContainer/Torch_r.text as int)
	
	S.set_bonfire_radius($Panel/MainContainer/VariantsContainer/BonfireContainer/HBoxContainer/Bonfire_r.text as int)
	
	S.set_arrow_radius($Panel/MainContainer/VariantsContainer/ArrowContainer/HBoxContainer/Arrow_r.text as int)
	
	S.set_chest_radius($Panel/MainContainer/VariantsContainer/ChestContainer/HBoxContainer/Chest_r.text as int)
	
	S.set_lvl1($Panel/MainContainer/VariantsContainer/LionContainer/HBoxContainer/lvl1_r.text as int,
				$Panel/MainContainer/VariantsContainer/LionContainer/HBoxContainer2/lvl1_limit.text as int)
				
	S.set_lvl2($Panel/MainContainer/VariantsContainer/DragonContainer/HBoxContainer/lvl2_r.text as int,
				$Panel/MainContainer/VariantsContainer/DragonContainer/HBoxContainer2/lvl2_limit.text as int)
				
func _ready():
	var sz = S.get_size()
	print(sz)
	$Panel/MainContainer/VariantsContainer/SizeContainer/HBoxContainer/N_Size.text = str(sz.x)
	$Panel/MainContainer/VariantsContainer/SizeContainer/HBoxContainer/M_Size.text = str(sz.y)
	
	$Panel/MainContainer/VariantsContainer/WallsContainer/HBoxContainer/Walls.text = str(S.get_walls())
	
	$Panel/MainContainer/VariantsContainer/TorchContainer/HBoxContainer/Torch_r.text = str(S.get_torch_radius())
	
	$Panel/MainContainer/VariantsContainer/BonfireContainer/HBoxContainer/Bonfire_r.text = str(S.get_bonfire_radius())
	
	$Panel/MainContainer/VariantsContainer/ArrowContainer/HBoxContainer/Arrow_r.text = str(S.get_arrow_radius())
	
	$Panel/MainContainer/VariantsContainer/ChestContainer/HBoxContainer/Chest_r.text = str(S.get_chest_radius())
	
	var lvl1 = S.get_lvl1()
	var lvl2 = S.get_lvl2()
	$Panel/MainContainer/VariantsContainer/LionContainer/HBoxContainer/lvl1_r.text = str(lvl1.radius)
	$Panel/MainContainer/VariantsContainer/LionContainer/HBoxContainer2/lvl1_limit.text = str(lvl1.limit)
	
	$Panel/MainContainer/VariantsContainer/DragonContainer/HBoxContainer/lvl2_r.text = str(lvl2.radius)
	$Panel/MainContainer/VariantsContainer/DragonContainer/HBoxContainer2/lvl2_limit.text = str(lvl2.limit)


func _on_Ok_pressed():
	_update()
	queue_free()

func _on_Cancel_pressed():
	queue_free()
