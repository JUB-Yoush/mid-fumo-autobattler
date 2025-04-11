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
	ability_descriptions = ["prevent one opponent summon","prevent one opponent summon","prevent one opponent summon"]
	spellcard_descriptions =["prevent all future summons this battle","prevent all future summons this battle","prevent all future summons this battle"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on fumo summoned"
	image = load("res://assets/fumo/Youmu.png")


	
func on_round_start(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	var ghost:Fumo = FumoFactory.make_fumo("ghost")
	summoned_fumo.emit(ghost,self.team_id)


func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	print("from fumo: " + name_str)
	var ghost:Fumo = FumoFactory.make_fumo("ghost")
	summoned_fumo.emit(ghost,self.team_id)
	area.clear_mp(max_mp)

