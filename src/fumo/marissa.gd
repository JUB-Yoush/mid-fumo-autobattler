extends Fumo

func _init() -> void:
	id = 001
	tier = 1
	name_str = "Marissa"
	price = 3
	hp = 2
	max_mp = 5
	atk = 2
	mp = 3
	exp_points = 1
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Marissa.png")


func on_round_start(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
