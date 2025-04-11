extends Item

func _init() -> void:	
	id = 001
	name_str = "Tanuki Leaf"
	ability_desc = "+1 exp"
	image = load("res://assets/items/c_leaf.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	fumo.exp_points += 1
	
	
