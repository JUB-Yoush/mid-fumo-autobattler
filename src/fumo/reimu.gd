extends Fumo
#extends Node

func _init() -> void:
	id = 009
	name_str = "Reimu"
	tier = 2
	price = 3
	hp = 3
	max_mp = 5
	atk = 3
	mp = 0
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Reimu.png")

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
	
