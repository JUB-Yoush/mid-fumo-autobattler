extends Fumo
class_name Sakuya

func _init() -> void:
	id = 003
	name_str = "Sakuya"
	price = 3
	hp = 2
	max_mp = 5
	atk = 2
	mp = 0
	ability_desc = "Sakuya morns the passing."
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Sakuya.png")


func on_ally_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("Rest in fumo...")

