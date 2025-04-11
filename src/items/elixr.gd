extends Item

func _init() -> void:	
	id = 001
	name_str = "Hourai Elixr"
	ability_desc = "+1 exp"
	image = load("res://assets/items/c_elixir.png")
	price = 3
	tier = 1

func on_sale(fumo:Fumo) -> void:
	fumo.exp_points += 1
	
	
