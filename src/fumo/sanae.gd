extends Fumo

func _init() -> void:
	id = 007
	tier = 1
	name_str = "Sanae"
	hp = 6
	max_mp = 10
	atk = 3
	ability_uses = 2
	ability_descriptions = ["Heal 5 hp from the front-line hp fumo.","Heal 8 hp from the front-line hp fumo.","Heal 11 hp from the front-line hp fumo."]
	spellcard_descriptions =["Heal all allies by 3 hp","Heal all allies by 4 hp","Heal all allies by 5 hp"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "after turn"
	image = load("res://assets/fumo/Sanae.png")


var ability_scale:Array[int] = [5,8,11]
var spellcard_scale:Array[int] = [3,4,5]
	
func on_turn_end(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
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
