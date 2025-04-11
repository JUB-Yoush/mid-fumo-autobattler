extends RefCounted
class_name Fumo

signal koed(fumo:Fumo)
signal spellcard_ready(fumo:Fumo)
signal leveled_up(fumo:Fumo)
signal summoned_fumo(fumo:Fumo)
signal changed_order()
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

var status:STATUSES = STATUSES.NORMAL

var area:FumoArea
var ability_descriptions:Array[String] = ["","",""]
var spellcard_descriptions:Array[String] = ["","",""]
var id:int
var name_str:String
var ability_desc:String = "N/A"
var spell_card_desc:String = "N/A"
var trigger_desc:String = "N/A"
var image:Texture2D
var price:int = 3
var tier:int
var level:int = 0
var in_party:bool
var is_temp:bool
var is_subtitution:bool = false
var in_shop:bool
var dead:bool
var used_spellcard:bool = false
var ability_uses:int = 1
var team_id :CombatData.TEAM
var prev_hp:int
var can_tank:bool = false
var negations :int = 0

var has_doll:bool = false:
	set(value):
		has_doll = value
		if area:
			area.dollIcon.visible = has_doll


var hp:int:
	set(value):
		prev_hp = hp
		if tanked(value - prev_hp):
			return
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
		if mp == max_mp and not used_spellcard and max_mp > 0:
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
			lvlup()
		if area:
			area.update_exp(exp_points)
	get:
		return exp_points

var remaining_status_time :int = 0:
	set(value):
		remaining_status_time = value
		if area:
			area.update_status_time(remaining_status_time)
		if remaining_status_time == 0:
			set_status(STATUSES.NORMAL,-1)

func lvlup() -> void:
			level += 1
			if ability_descriptions[0] != "":
				ability_desc = ability_descriptions[level]
			if spellcard_descriptions[0] != "":
				spell_card_desc = spellcard_descriptions[level]

			if area:
				area.update_labels(ability_desc,spell_card_desc)
			leveled_up.emit()

func tanked(hp_diff:int) -> bool:
	if hp_diff < 0 and can_tank and negations > 0:
		negations -= 1
		return true
	return false
	
func set_status(new_status:STATUSES,status_duration:int) -> void:
	#var prev_status:STATUSES = status
	if status == new_status:
		remaining_status_time += status_duration
	status = new_status
	match(new_status):
		STATUSES.NORMAL:
			if area:
				area.is_blue = false

		STATUSES.FROZEN:
			remaining_status_time = status_duration
			if area:
				area.is_blue = true
		STATUSES.BLIND:
			if area:
				area.set_color("#ff00ff")
	pass

func summon_doll(allies:Array[Fumo],opponents:Array[Fumo]) -> void:
	var doll:Fumo = FumoFactory.make_fumo("doll")
	summoned_fumo.emit(doll,self.team_id)

func spellcard(allies:Array[Fumo],opponents:Array[Fumo]) -> void:
	print("This fumo has no spellcard made yet. Blame Jayden.")
	if area and not dead:
		area.clear_mp(max_mp)
	pass

func _to_string() -> String:
	return "%s|hp:%d|atk:%d|mp:%d/%d" % [name_str, hp, atk, mp, max_mp]
