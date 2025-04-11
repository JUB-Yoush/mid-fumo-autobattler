extends Fumo
class_name Barrier

func _init() -> void:
	id = 025
	name_str = "Barrier"
	price = 3
	hp = 1
	atk = 0
	max_mp = 0
	mp = 0
	is_subtitution = true
	image = load("res://assets/items/c_orb.png")

var reimu_lvl:int
var ability_scale:Array[int] = [1,2,3]

func on_ko(allies:Array[Fumo], opponents: Array[Fumo]) -> void:
	if opponents.is_empty():
		return
	opponents.insert(min(ability_scale[reimu_lvl],opponents.size()),opponents.pop_front())
