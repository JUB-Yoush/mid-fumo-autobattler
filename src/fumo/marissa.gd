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
	spell_card_desc = "+99 mp to front line fumo"
	trigger_desc = "on ally ko"
	image = load("res://assets/fumo/Marissa.png")

	ability_descriptions = ["Gain 2 hp and 2 atk when an ally feints.","Gain 3 hp and 3 atk when an ally feints.","Gain 4 hp and 4 atk when an ally feints."]
	#spellcard_descriptions = ["Instantly fill front-line fumo's mp","Instantly fill front-line fumo's mp","Instantly fill front-line fumo's mp",]
	ability_desc = ability_descriptions[level]
	#@spell_card_desc = spellcard_descriptions[level]

var ability_scale:Array[int] = [2,3,4]

func on_ally_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	hp += 2
	mp += 3

func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	if allies.is_empty():
		return
	allies[0].mp = allies[0].max_mp
	if area and not dead:
		area.clear_mp(max_mp)

