extends Fumo

func _init() -> void:
	id = 000
	name_str = "Dummyko"
	tier = 1
	price = 3
	hp = 1
	max_mp = 5
	atk = 1
	mp = 0
	ability_desc = "Nothing."
	spell_card_desc = "Lorem Ipsum? Who is she? Why can't I reach her?"
	trigger_desc = "on round start"
	image = load("res://assets/fumo/Cirno.png")


func on_ko(allies:Array[Fumo], _opponents: Array[Fumo]) -> void:
	var fumo := FumoFactory.make_fumo("marissa")
	summoned_fumo.emit(fumo,self.team_id)
