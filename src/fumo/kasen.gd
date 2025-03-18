extends Fumo

func _init() -> void:
	id = 004
	name_str = "Kasen"
	price = 3
	hp = 2
	max_mp = 5
	atk = 2
	mp = 0
	ability_desc = "Buff mp regen rate by 25% for all allies for <lvl> turns"
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Kasen.png")


func on_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	var fumo := FumoFactory.make_fumo("marissa")
	print("summoning a marissa")
	summoned_fumo.emit(fumo,self.team_id)
#	await action_completed

