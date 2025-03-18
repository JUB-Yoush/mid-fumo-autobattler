extends Fumo

func _init() -> void:
	id = 003
	name_str = "Sumireko"
	price = 3
	hp = 1
	max_mp = 5
	atk = 1
	mp = 5
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/"+name_str+".png")



func on_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print(name_str + " uses ability: mp distribution")
	# distribute remaining mp across allies
	for ally in allies:
		var mp_diff:int= ally.max_mp - ally.mp
		ally.mp += min(mp_diff, mp)
		mp -= min(mp_diff, mp)
		if mp == 0:
			break
