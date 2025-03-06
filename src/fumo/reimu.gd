extends Fumo
class_name Reimu
#extends Node

func _init() -> void:
	id = 002
	name_str = "Reimu"
	price = 3
	hp = 3
	max_mp = 5
	atk = 3
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Reimu.png")


func on_round_start(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)

