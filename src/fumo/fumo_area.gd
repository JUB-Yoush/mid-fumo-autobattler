extends Area2D
class_name FumoArea

var fumo:Fumo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = fumo.image		
	%NameLabel.text = fumo.name_str
	%CostLabel.text = str(fumo.price)
	%HoverIcon.texture = fumo.image
	%TriggerLabel.text = fumo.trigger_desc
	%AbilityLabel.text = fumo.ability_desc
	%SpellLabel.text = fumo.spell_card_desc

func _set_fumo(new_fumo:Fumo) -> void:
	fumo = new_fumo
	_update_fumo_data()

func _update_fumo_data() -> void:
	$Sprite2D.texture = fumo.image		
	%NameLabel.text = fumo.name_str
	%CostLabel.text = str(fumo.price)
	%HoverIcon.texture = fumo.image
	%TriggerLabel.text = fumo.trigger_desc
	%AbilityLabel.text = fumo.ability_desc
	%SpellLabel.text = fumo.spell_card_desc
