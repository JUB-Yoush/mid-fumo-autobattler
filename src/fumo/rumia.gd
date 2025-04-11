extends Fumo

func _init() -> void:
	id = 006
	name_str = "Rumia"
	tier = 2
	hp = 1
	max_mp = 10
	atk = 5
	mp = 0
	trigger_desc = "on round start"
	image = load("res://assets/fumo/"+name_str+".png")

	ability_descriptions = ["Distribute mp to ally fumo","gain + 2 mp, distribute mp to ally fumo"," gain + 4 mp, distribute mp to ally fumo"]
	spellcard_descriptions = ["+3 mag to all allies","+4 mag to all allies","+ 5 mag to all allies"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]

var ability_scale:Array[int] = [2,3,4]
var spellcard_scale:Array[int] = [3,4,5]

func on_round_start(_allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	if opponents.is_empty():
		return
	opponents[0].set_status(Fumo.STATUSES.BLIND,-1)

func spellcard(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	if opponents.is_empty():
		return
	for opponent in opponents:
		if opponent.status == Fumo.STATUSES.UNLUCKY:
			opponent.set_status(Fumo.STATUSES.BLIND,-1)
			return
	opponents.pick_random().set_status(Fumo.STATUSES.BLIND,-1)
	if area and not dead:
		area.clear_mp(max_mp)
