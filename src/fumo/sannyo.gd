extends Fumo

func _init() -> void:
	id = 008
	tier = 1
	name_str = "sannyo"
	hp = 6
	max_mp = 5
	atk = 2
	ability_uses = 1
	ability_descriptions = ["prevent enemy ability from triggering","prevent enemy ability from triggering","prevent enemy ability from triggering"]
	spellcard_descriptions =["Use a random allies spellcard.","Use a random allies spellcard.","Use a random allies spellcard."]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on opponent ability"
	image = load("res://assets/fumo/Sannyo.png")
	
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
