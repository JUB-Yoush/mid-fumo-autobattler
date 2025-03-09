extends Fumo
class_name Marissa 
#extends Node

func _init() -> void:
	id = 001
	name_str = "Marissa"
	price = 3
	hp = 2
	max_mp = 5
	atk = 2
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Marissa.png")

# var on_round_start:Callable = func(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
# 	print("from fumo: " + name_str)

func on_round_start(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)

func on_ko(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	print("death ability!!! curse of the pharoh!!!" + name_str)
