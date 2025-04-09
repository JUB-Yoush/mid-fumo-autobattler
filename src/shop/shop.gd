extends Node

var fumoMap:Dictionary[Fumo,FumoArea]

const ITEM_OFFSET:int = 64
const FUMO_OFFSET:int = 150

const fumoAreaScene = preload("res://src/fumo/fumo_area.tscn")

@onready var shopItems:Node2D = $ShopItems
@onready var shopFumo:Node2D = $ShopFumo
@onready var shopParty:Node2D = $Party
@onready var party :Array[Fumo] = GlobalRefs.get_player_party()

var overlapping_area:Area2D
var selected_area:Area2D
var original_area_position:Vector2
func _ready() -> void:
	# load in player party
	# load in items
	# load in fumo
	party = FumoFactory.make_fumos(["marissa","reimu","marissa","reimu","marissa"])
	render_party()
	render_shop_items(get_shop_sizes()[1])
	pass

func render_party() -> void:
	for fumo:Fumo in party:
		var newFumoArea :FumoArea = fumoAreaScene.instantiate()
		newFumoArea.fumo = fumo
		fumoMap[fumo] = newFumoArea
		shopParty.add_child(newFumoArea)
		newFumoArea.global_position.x = shopParty.position.x - (shopParty.get_child_count() * FUMO_OFFSET)
		newFumoArea.global_position.y = shopParty.position.y
		#newFumoArea.original_position = Vector2(newFumoArea.global_position.x,newFumoArea.global_position.y)
		newFumoArea.mouse_entered.connect(set_overlapping_area.bind(newFumoArea))
		newFumoArea.mouse_exited.connect(clear_overlapping_area.bind(newFumoArea))

func set_overlapping_area(area:Area2D) -> void:
	if selected_area != null:
		if selected_area.is_in_group("fumo") == area.is_in_group("fumo"):
			var temp:Vector2 = original_area_position
			original_area_position = Vector2(area.global_position.x,area.global_position.y)
			area.global_position = Vector2(temp.x, temp.y)

			var area_index:int = party.find(area.fumo)
			var selected_index:int = party.find(selected_area.fumo)
			var temp2:Fumo = party[area_index]
			party[area_index] = party[selected_index]
			party[selected_index] = temp2 
			print(party)

		return
	else:
		overlapping_area = area
		original_area_position = overlapping_area.global_position
		if area.is_in_group("fumo"):
			area.hover_info.visible = true

func clear_overlapping_area(area:Area2D) -> void:
	if area.is_in_group("fumo"):
		area.hover_info.visible = false
	if area != overlapping_area:
		return
	overlapping_area = null

func render_shop_items(count:int) -> void:
	pass
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("click") and overlapping_area != null:
		selected_area = overlapping_area
		overlapping_area.global_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("click") and overlapping_area != null:
		selected_area.global_position = original_area_position
		selected_area = null


func get_shop_sizes() -> Array[int]:
	var lvl :int= GlobalRefs.player_lvl
	if lvl > 0 and lvl <= 5:
		return [3,1]
	elif lvl > 3 and lvl <= 5:
		return [4,2]
	elif lvl > 5 and lvl <= 9:
		return [5,2]
	else:
		return [5,2]
