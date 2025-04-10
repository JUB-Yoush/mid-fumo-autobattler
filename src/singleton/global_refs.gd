extends Node

const COMBAT_SCENE :PackedScene = preload("res://src/combat/combat.tscn") 
const SHOP_SCENE :PackedScene = preload("res://src/shop/shop.tscn")

const TEAM_LIMIT:= 5
const FUMO_PRICE:= 3
const WIN_REQUIREMENT:int = 7
const LOSS_REQUIREMENT:int = 5

var _player_party:Array[Fumo]
var _battle_party:Array[Fumo]
var player_lvl :int= 1
var tier:int = 1
var wins :int= 0
var losses :int= 0

var frozen_items :Array[Item] = []
var frozen_fumo :Array[Fumo] = []

var turns :int= 1:
	set(value):
		turns = value
		set_current_tier()
	get:
		return turns


func set_player_party(new_party:Array[Fumo]) -> void:
	_player_party = new_party

func get_player_party() -> Array[Fumo]:
	return _player_party

func get_battle_party() -> Array[Fumo]:
	return _battle_party

func clone_player_party() -> Array[Fumo]:
	return _player_party.duplicate()

func start_battle() -> void:
	_battle_party = _player_party.duplicate(true)
	print_debug(_battle_party)
	get_tree().change_scene_to_packed(COMBAT_SCENE)

func battle_ended(result:CombatData.RESULTS) -> void:
	match result:
		CombatData.RESULTS.WIN:
			wins += 1
		CombatData.RESULTS.LOSS:
			losses += 1
	turns += 1
	get_tree().change_scene_to_packed(SHOP_SCENE)

func set_current_tier() -> void:
	if turns >= 0 and turns < 3:
		tier = 1
	elif turns >= 3 and turns < 5:
		tier = 2
	elif turns >= 5 and turns < 7:
		tier = 3
	elif turns >= 7 and turns < 9:
		tier = 4
	else:
		tier = 1

func set_frozen_shop(fumos:Array[Fumo],items:Array[Item]) -> void:
	frozen_items = items
	frozen_fumo = fumos

func get_frozen_shop() -> Array:
	return[frozen_fumo,frozen_items]
	
