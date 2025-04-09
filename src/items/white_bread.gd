extends Item

func _init() -> void:	
	id = 001
	name_str = "White Bread"
	ability_desc = "+2 Health"
	image = load("res://src/items/white_bread.gd")
	price = 3
	tier = 1

func _on_sale(fumo:Fumo) -> void:
	fumo.hp += 2
	
	
