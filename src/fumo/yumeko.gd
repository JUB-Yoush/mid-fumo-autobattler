extends Fumo
#extends Node

func _init() -> void:
	id = 011
	name_str = "Yumeko"
	tier = 2
	price = 3
	hp = 3
	max_mp = 5
	atk = 3
	mp = 0
	ability_desc = "Summon a 1 hp 3 atk sword"
	spell_card_desc = "Summon another 1hp 3 atk sword"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Yumeko.png")

var spellcard_scale:Array[int] = [4,5,6]


func on_round_start(_allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	var sword:Fumo = FumoFactory.make_fumo("sword")
	summoned_fumo.emit(sword,self.team_id)

func spellcard(_allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	var sword:Fumo = FumoFactory.make_fumo("sword")
	sword.atk = spellcard_scale[level]
	summoned_fumo.emit(sword,self.team_id)
	if area and not dead:
		area.clear_mp(max_mp)
	
