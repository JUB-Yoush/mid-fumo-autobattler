extends Item

func _init() -> void:	
	id = 001
	name_str = "Doll"
	ability_desc = "summon a 1 atk 3 hp doll when you feint"
	image = load("res://assets/items/c_doll.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	fumo.has_doll = true
	
	
