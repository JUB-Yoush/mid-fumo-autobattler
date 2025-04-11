extends Fumo

func _init() -> void:
	id = 007
	tier = 2
	name_str = "Sanae"
	hp = 6
	max_mp = 10
	atk = 3
	ability_uses = 2
	ability_descriptions = ["prevent one opponent summon","prevent one opponent summon","prevent one opponent summon"]
	spellcard_descriptions =["prevent all future summons this battle","prevent all future summons this battle","prevent all future summons this battle"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on fumo summoned"
	image = load("res://assets/fumo/Sanae.png")


var ability_scale:Array[int] = [5,8,11]
var spellcard_scale:Array[int] = [3,4,5]
	
func on_after_turn(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	if allies.is_empty():
		return
	allies[0].hp += ability_scale[level]
	ability_uses -= 1


func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	if allies.is_empty():
		return
	for ally in allies:
		ally.hp += spellcard_scale[level]
	if area and not dead:
		area.clear_mp(max_mp)
