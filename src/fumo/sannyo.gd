extends Fumo

func _init() -> void:
	id = 008
	tier = 2
	name_str = "sannyo"
	hp = 6
	max_mp = 10
	atk = 2
	ability_uses = 1
	ability_descriptions = ["prevent one opponent summon","prevent one opponent summon","prevent one opponent summon"]
	spellcard_descriptions =["prevent all future summons this battle","prevent all future summons this battle","prevent all future summons this battle"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on opponent ability"
	image = load("res://assets/fumo/Sannyo.png")


var ability_scale:Array[int] = [5,8,11]
var spellcard_scale:Array[int] = [3,4,5]
	
# func on_after_turn(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
# 	if allies.is_empty():
# 		return
# 	allies[0].hp += ability_scale[level]
# 	ability_uses -= 1


func spellcard(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	if allies.is_empty():
		return

	var ally:Fumo = allies.pick_random()
	while ally == self:
		ally = allies.pick_random()
	ally.call("spellcard",allies,opponents)
	ally.area.set_mp_tokens(ally.max_mp)
	ally.area.update_mp(ally.mp)
	if area and not dead:
		area.clear_mp(max_mp)
