extends Fumo

func _init() -> void:
	id = 001
	tier = 1
	name_str = "Shinmyoumaru"
	price = 3
	hp = 4
	atk = 1
	mp = 0
	max_mp = 7
	exp_points = 0
	ability_descriptions = ["+2 atk and hp to front-line fumo","+4 atk and hp to front-line fumo","+6 atk and hp to front-line fumo"]
	spellcard_descriptions = ["+2 atk and hp to all ally fumo","+4 atk and hp to all ally fumo","+6 atk and hp to all ally fumo"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on battle start"
	image = load("res://assets/fumo/Shinmyoumaru.png")

var ability_scale:Array[int] = [2,4,6]

func on_round_start(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	if allies.is_empty():
		return
	allies[0].hp += ability_scale[level]
	allies[0].atk += ability_scale[level]

func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	if allies.is_empty():
		return
	for ally in allies:
		ally.hp += ability_scale[level]
		ally.atk += ability_scale[level]

