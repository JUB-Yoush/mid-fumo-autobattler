extends Fumo

func _init() -> void:
	id = 004
	name_str = "Ghost"
	price = 3
	hp = 4
	max_mp = 6
	atk = 1
	mp = 5
	image = load("res://assets/fumo/"+name_str+".png")

	ability_descriptions = ["Distribute mp to ally fumo","gain + 2 mp, distribute mp to ally fumo"," gain + 4 mp, distribute mp to ally fumo"]
	spellcard_descriptions = ["+3 mag to all allies","+4 mag to all allies","+ 5 mag to all allies"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]

var ability_scale:Array[int] = [0,2,3]
var spellcard_scale:Array[int] = [3,4,5]

func on_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print(name_str + " uses ability: mp distribution")
	# distribute remaining mp across allies
	mp += ability_scale[level]
	for ally in allies:
		var mp_diff:int= ally.max_mp - ally.mp
		ally.mp += min(mp_diff, mp)
		mp -= min(mp_diff, mp)
		if mp == 0:
			break

func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	if allies.is_empty():
		return
	var mp_given:int = spellcard_scale[level]
	for ally in allies:
		ally.mp += mp_given
	area.clear_mp(max_mp)
