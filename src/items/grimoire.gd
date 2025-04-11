extends Item

func _init() -> void:	
	id = 001
	name_str = "Grimoire"
	ability_desc = "start next battle with +7 mp"
	image = load("res://assets/items/c_grimoir.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	fumo.mp += 7
	
	
