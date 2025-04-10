extends Area2D
class_name ItemArea

var item:Item

var frozen:bool = false:
	set(value):
		frozen = value
		if frozen:
			$Sprite2D.modulate = Color("#0083c9")
		else:
			$Sprite2D.modulate = Color("#ffffff")

@onready var hover_info :Panel = $Control/HoverInfo

func _ready() -> void:
	add_to_group("item")
	%HoverInfo.visible = false
	set_item(item)

func set_item(new_item:Item) -> void:
	item = new_item
	item.area = self
	if not is_node_ready():
		return
	%Sprite2D.texture = item.image
	%HoverIcon.texture = item.image
	%NameLabel.text = item.name_str
	%CostLabel.text = str(item.price)
	%AbilityLabel.text = item.ability_desc
