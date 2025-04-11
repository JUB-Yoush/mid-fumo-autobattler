extends Fumo

func _init() -> void:
	id = 024
	name_str = "Ghost"
	price = 3
	hp = 1
	atk = 1
	max_mp = 0
	mp = 0
	is_subtitution = true
	image = load("res://assets/summons/"+name_str+".png")

# func on_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
# 	print(name_str + " uses ability: mp distribution")
# 	# distribute remaining mp across allies
# 	mp += ability_scale[level]
# 	for ally in allies:
# 		var mp_diff:int= ally.max_mp - ally.mp
# 		ally.mp += min(mp_diff, mp)
# 		mp -= min(mp_diff, mp)
# 		if mp == 0:
# 			break

# func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
# 	if allies.is_empty():
# 		return
# 	var mp_given:int = spellcard_scale[level]
# 	for ally in allies:
# 		ally.mp += mp_given
# 	area.clear_mp(max_mp)
