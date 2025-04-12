extends Fumo

func _init() -> void:
	id = 004
	tier = 1
	name_str = "Youmu"
	hp = 3
	max_mp = 10
	atk = 2
	mp = 0
	ability_uses = 1
	ability_descriptions = ["Summon a 1 hp 1 atk Spirit.","Summon a 1 hp 1 atk Spirit.","Summon a 1 hp 1 atk Spirit."]
	spellcard_descriptions = ["Summon another 1 hp 1 atk Spirit.","Summon another 1 hp 1 atk Spirit.","Summon another 1 hp 1 atk Spirit."]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Youmu.png")


func on_round_start(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	var ghost:Fumo = FumoFactory.make_fumo("ghost")
	summoned_fumo.emit(ghost,self.team_id)


func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	var ghost:Fumo = FumoFactory.make_fumo("ghost")
	summoned_fumo.emit(ghost,self.team_id)
	if area and not dead:
		area.clear_mp(max_mp)
	area.clear_mp(max_mp)
