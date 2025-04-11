extends RefCounted
class_name Fumo

signal koed(fumo:Fumo)
signal spellcard_ready(fumo:Fumo)
signal leveled_up(fumo:Fumo)
signal summoned_fumo(fumo:Fumo)
signal action_completed
# signal spell_ready

const MAX_HP:int = 99
const MAX_ATK:int = 99
const MAX_EXP:int = 5
const LEVEL_REQUIREMENTS = [2,5]

enum STATUSES{
NORMAL,
FROZEN,
UNLUCKY,
BLIND
}

var area:FumoArea

var id:int
var name_str:String
var ability_desc:String
var spell_card_desc:String
var trigger_desc:String
var image:Texture2D
var price:int
var tier:int
var level:int = 0
#var status:Statuses
var in_party:bool
var is_temp:bool
var in_shop:bool
var dead:bool
var used_spellcard:bool = false
var team_id :CombatData.TEAM


var hp:int:
	set(value):
		hp = clamp(value,0,MAX_HP)
		if area:
			area.update_hp(hp)
		if hp == 0:
			dead = true
			koed.emit(self)
	get:
		return hp

var max_mp:int
var mp:int = 0:
	set(value):
		if used_spellcard: 
			return
		mp = clamp(value,0,max_mp)
		if mp == max_mp and not used_spellcard:
			spellcard_ready.emit(self)	
			used_spellcard = true
		if area:
			area.update_mp(mp)
	get:
		return mp

var atk:int:
	set(value):
		atk = clamp(value,0,MAX_ATK)
		if area:
			area.update_atk(atk)
	get:
		return atk

var exp_points:int:
	set(value):
		if level == 2:
			return
		exp_points = clamp(value,0,MAX_EXP)
		if exp_points >= LEVEL_REQUIREMENTS[level]: 
			level += 1
			leveled_up.emit()
		if area:
			area.update_exp(exp_points)
	get:
		return exp_points

func spellcard(allies:Array[Fumo],opponents:Array[Fumo]) -> void:
	print("This fumo has no spellcard made yet. Blame Jayden.")
	if area and not dead:
		area.clear_mp(max_mp)
	pass

func _to_string() -> String:
	return "%s|hp:%d|atk:%d|mp:%d/%d" % [name_str, hp, atk, mp, max_mp]
