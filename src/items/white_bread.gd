extends Item

func _init() -> void:	
	id = 001
	name_str = "White Bread"
	ability_desc = "+2 Health"
	image = load("res://assets/items/c_bread.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	fumo.hp += 2
	
	
