extends Area2D
class_name FumoArea

var fumo:Fumo
var is_fumo:bool = true

const mag_texture:Texture = preload("res://assets/ui/mana_e.png")

@onready var ui:Control = $UI
@onready var hover_info:Control = $UI/HoverInfo
@onready var animPlayer:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("fumo")
	$Sprite2D.texture = fumo.image		
	%NameLabel.text = fumo.name_str
	%CostLabel.text = str(fumo.price)
	%HoverIcon.texture = fumo.image
	%TriggerLabel.text = fumo.trigger_desc
	%AbilityLabel.text = fumo.ability_desc
	%SpellLabel.text = fumo.spell_card_desc
	hover_info.visible = false


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
