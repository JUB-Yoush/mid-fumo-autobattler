extends Fumo
#extends Node

func _init() -> void:
	id = 009
	name_str = "Reimu"
	tier = 1
	price = 3
	hp = 5
	max_mp = 5
	atk = 2
	mp = 0
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Reimu.png")

	ability_descriptions = ["Summon a 1 hp 1 atk Orb that pushes back the front-line fumo back 1 space.","Summon a 1 hp 1 atk Orb that pushes back the front-line fumo back 2 spaces.","Summon a 1 hp 1 atk Orb that pushes back the front-line fumo back 3 spaces."]
	spellcard_descriptions = ["Summon another 1 hp 4 atk Orb.","Summon another 1 hp 5 atk Orb.","Summon another 1 hp 6 atk Orb."]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]

var ability_scale:Array[int] = [1,2,3]
var spellcard_scale:Array[int] = [4,5,6]


func on_round_start(_allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	var barrier:Barrier = FumoFactory.make_fumo("barrier")
	barrier.reimu_lvl = level
	summoned_fumo.emit(barrier,self.team_id)

func spellcard(_allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	var barrier:Barrier = FumoFactory.make_fumo("barrier")
	barrier.atk = spellcard_scale[level]
	barrier.reimu_lvl = level
	summoned_fumo.emit(barrier,self.team_id)
	if area and not dead:
		area.clear_mp(max_mp)
	
