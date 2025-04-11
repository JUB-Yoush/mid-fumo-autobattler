extends Fumo

func _init() -> void:
	id = 010
	tier = 1
	name_str = "Marissa"
	price = 3
	hp = 2
	max_mp = 10
	atk = 2
	mp = 0
	exp_points = 1
	ability_desc = "+1 mp to front-line fumo"
	spell_card_desc = "+99 mp to front line fumo"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Marissa.png")

# func on_round_start(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
# 	print("from fumo: " + name_str)
# 	print("NOTHING HAPPENDED")

func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	if area and not dead:
		area.clear_mp(max_mp)

