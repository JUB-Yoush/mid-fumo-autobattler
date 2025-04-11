extends Item

func _init() -> void:	
	id = 001
	name_str = "Amanojaku Horn"
	ability_desc = "Swap your hp and atk"
	image = load("res://assets/items/c_horn.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	var temp: = fumo.hp
	fumo.hp = fumo.atk
	fumo.atk = temp
	
	
