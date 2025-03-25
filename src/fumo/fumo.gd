extends RefCounted
class_name Fumo

signal koed(fumo:Fumo)
signal summoned_fumo(fumo:Fumo)
signal action_completed
# signal spell_ready

const MAX_HP:int = 99
const MAX_ATK:int = 99

var id:int
var name_str:String
var ability_desc:String
var spell_card_desc:String
var trigger_desc:String
var image:Texture2D
var price:int
var tier:int
#var status:Statuses
var in_party:bool
var is_temp:bool
var in_shop:bool
var dead:bool
var team_id :CombatData.TEAM


var hp:int:
	set(value):
		hp = clamp(value,0,MAX_HP)
		print("%s hp set to %d" % [name_str, hp])
		if hp == 0:
			koed.emit(self)
	get:
		return hp
			

var max_mp:int
var mp:int = 0:
	set(value):
		mp = clamp(value,0,max_mp)
		if mp == max_mp:
			pass
	get:
		return mp

var atk:int:
	set(value):
		atk = clamp(value,0,MAX_ATK)
	get:
		return atk

func _to_string() -> String:
	return "%s|hp:%d|atk:%d|mp:%d/%d" % [name_str, hp, atk, mp, max_mp]
