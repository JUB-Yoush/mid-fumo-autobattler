extends Control

func _ready() -> void:
	%ReturnButton.pressed.connect(GlobalRefs.start_new_game)
