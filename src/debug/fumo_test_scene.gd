extends Node2D

func _ready():
	var testFumo = FumoFactory.make_fumo("marissa")
	add_child(testFumo)

