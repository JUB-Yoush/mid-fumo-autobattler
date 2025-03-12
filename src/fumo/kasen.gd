extends Fumo
class_name Marissa 

func _init() -> void:
	id = 004
	name_str = "Kasen"
	price = 3
	hp = 2
	max_mp = 5
	atk = 2
	mp = 0
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/kasen.png")


func on_summon(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	pass
	

