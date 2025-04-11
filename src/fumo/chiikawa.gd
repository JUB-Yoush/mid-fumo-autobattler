extends Fumo

func _init() -> void:
	id = 003
	tier = 1
	name_str = "Chiikawa"
	price = 3
	hp = 5
	atk = 1
	max_mp = 5
	can_tank = true
	exp_points = 0
	ability_descriptions = ["Jump to front line, +2 hp","Jump to front line +4 hp","Jump to front line, +6 hp"]
	spellcard_descriptions = ["next hit deals no damage","next 2 hits deal no damage","next 3 hits deal no damage"]
	ability_desc = ability_descriptions[level]
	spell_card_desc = spellcard_descriptions[level]
	trigger_desc = "on ally ko"
	image = load("res://assets/fumo/Chiikawa.png")
	used_spellcard = false

var ability_scale:Array[int] = [2,4,6]
var spellcard_scale:Array[int] = [1,2,3]


func on_ally_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	if allies.is_empty():
		return
	allies.push_front(allies.pop_at(allies.find(self)))
	self.hp += ability_scale[level]
	changed_order.emit()

func spellcard(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	#breakpoint
	print("IRON CHIIKAWA")
	if allies.is_empty():
		return
	negations = spellcard_scale[level]
	if area and not dead:
		area.clear_mp(max_mp)
	area.clear_mp(max_mp)

