extends Node


var _player_party:Array[Fumo]
var player_lvl :int= 1

func set_player_party(new_party:Array[Fumo]) -> void:
	_player_party = new_party

func get_player_party() -> Array[Fumo]:
	return _player_party

func clone_player_party() -> Array[Fumo]:
	return _player_party.duplicate()



