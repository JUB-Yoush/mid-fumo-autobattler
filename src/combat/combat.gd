extends Node
class_name Combat

var combat_data :CombatData

func _ready() -> void:
	_start_combat()


func _start_combat() -> void:
	combat_data = CombatData.new()


