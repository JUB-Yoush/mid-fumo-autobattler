extends Item

func _init() -> void:	
	id = 002
	name_str = "Yin Yang Orb"
	ability_desc = "+2 Atk"
	image = load("res://assets/items/c_orb.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	fumo.atk += 2
	
	
