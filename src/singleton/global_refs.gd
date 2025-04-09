extends Node


var _player_party:Array[Fumo]
var player_lvl :int= 1
var teir:int

var turns :int= 1:
	set(value):
		turns = value
		set_current_teir()
	get:
		return turns

func set_player_party(new_party:Array[Fumo]) -> void:
	_player_party = new_party

func get_player_party() -> Array[Fumo]:
	return _player_party

func clone_player_party() -> Array[Fumo]:
	return _player_party.duplicate()


func set_current_teir() -> void:
	if turns >= 0 and turns < 3:
		teir = 1
	elif turns >= 3 and turns < 5:
		teir = 2
	elif turns >= 5 and turns < 7:
		teir = 3
	elif turns >= 7 and turns < 9:
		teir = 4
	else:
		teir = 1
	
