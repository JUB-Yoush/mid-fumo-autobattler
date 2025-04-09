extends Area2D
class_name ItemArea

var item:Item
@onready var hover_info :Panel = $Control/HoverInfo

func _ready() -> void:
	add_to_group("item")
	%HoverInfo.visible = false
	set_item(item)

func set_item(new_item:Item) -> void:
	item = new_item
	if not is_node_ready():
		return
	%Sprite.texture = item.image
	%HoverIcon.texture = item.image
	%NameLabel.text = item.name_str
	%CostLabel.text = str(item.price)
	%AbilityLabel.text = item.ability_desc
