extends Fumo

func _init() -> void:
	id = 000
	name_str = "Cirno"
	hp = 2
	max_mp = 8
	atk = 2
	mp = 7
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
	opponents[0].set_status(Fumo.STATUSES.FROZEN,ability_scale[level])

func spellcard(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	if opponents.is_empty():
		return
	var targets:Array[Fumo] = []
	var target_count :int = min(spellcard_scale[level],opponents.size())

	for opponent in opponents:
		if opponent.status == Fumo.STATUSES.UNLUCKY and targets.size() < target_count:
			targets.append(opponent)

	while targets.size() < target_count:
		var rng:Fumo = opponents.pick_random()
		if not rng in targets:
			targets.append(rng)

	for target:Fumo in targets:
		target.set_status(Fumo.STATUSES.FROZEN,ability_scale[level])

	if area and not dead:
		area.clear_mp(max_mp)
