extends Node
class_name Fumo

# signal feinted
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


var hp:int:
	set(value):
		hp = clamp(value,0,MAX_HP)
		if hp == 0:
			pass
	get:
		return hp
			

var max_mp:int
var mp:int:
	set(value):
		mp = clamp(value,0,max_mp)
		if mp == max_mp:
			pass
	get:
		return hp

var atk:int:
	set(value):
		atk = clamp(value,0,MAX_ATK)
	get:
		return atk





