extends Fumo

func _init() -> void:
	id = 002
	tier = 1
	name_str = "Kasen"
	price = 3
	hp = 4
	max_mp = 13
	atk = 3
	mp = 0
	ability_uses = 1
	ability_descriptions = ["prevent one opponent summon","prevent one opponent summon","prevent one opponent summon"]
	spellcard_descriptions =["prevent all future summons this battle","prevent all future summons this battle","prevent all future summons this battle"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on fumo summoned"
	image = load("res://assets/fumo/Kasen.png")


func block_opponent_summon() -> void:
	# blocks the summon but this is hard_coded
	pass


