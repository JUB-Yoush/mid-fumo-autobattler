extends Area2D
class_name FumoArea

var fumo:Fumo
var is_fumo:bool = true

const mag_filled_texture:Texture = preload("res://assets/ui/mana_f.png")
const mag_empty_texture:Texture = preload("res://assets/ui/mana_e.png")

@onready var ui:Control = $UI
@onready var hover_info:Panel = $UI/HoverInfo
@onready var animPlayer:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hover_info.visible = false
	add_to_group("fumo")
	set_fumo(fumo)
	# $Sprite2D.texture = fumo.image		
	# %NameLabel.text = fumo.name_str
	# %CostLabel.text = str(fumo.price)
	# %HoverIcon.texture = fumo.image
	# %TriggerLabel.text = fumo.trigger_desc
	# %AbilityLabel.text = fumo.ability_desc
	# %SpellLabel.text = fumo.spell_card_desc


func set_fumo(new_fumo:Fumo) -> void:
	_set_fumo_data(new_fumo)

func _set_fumo_data(new_fumo:Fumo) -> void:
	fumo = new_fumo
	fumo.area = self
	$Sprite2D.texture = fumo.image		
	%NameLabel.text = fumo.name_str
	%CostLabel.text = str(fumo.price)
	%HoverIcon.texture = fumo.image
	%TriggerLabel.text = fumo.trigger_desc
	%AbilityLabel.text = fumo.ability_desc
	%SpellLabel.text = fumo.spell_card_desc
	set_mp_tokens(fumo.max_mp)
	update_hp(fumo.hp)
	update_atk(fumo.atk)
	update_mp(fumo.mp)

func set_mp_tokens(max_mp:int) -> void:
	for i in range(max_mp):
		var magTexture:TextureRect = %MpGrid.get_node("TextureRect%d" % i)
		magTexture.texture = mag_empty_texture
		magTexture.visible = true

func update_hp(value:int) -> void:
	%HpLabel.text = str(value)
	
func update_atk(value:int) -> void:
	%AttackLabel.text = str(value)
	
func update_mp(value:int) -> void:
	for i in range(value):
		var magTexture:TextureRect = %MpGrid.get_node("TextureRect%d" % i)
		magTexture.texture = mag_filled_texture
		magTexture.visible = true

func update_exp(value:int) -> void:
	pass
