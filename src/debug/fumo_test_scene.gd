extends Node2D

func _ready() -> void:
	var testFumo:FumoArea = FumoFactory.make_fumo_area("reimu")
	add_child(testFumo)
