extends Control

func _ready() -> void:
	if GlobalRefs.last_result == CombatData.RESULTS.WIN:
		%ResultLabel.text = "WIN!"
	if GlobalRefs.last_result == CombatData.RESULTS.LOSS:
		%ResultLabel.text = "LOSE :("
	%ReturnButton.pressed.connect(GlobalRefs.start_new_game)
