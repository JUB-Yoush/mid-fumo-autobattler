extends Node

var fumoMap:Dictionary[Fumo,FumoArea]

const ITEM_OFFSET:int = 150
const FUMO_OFFSET:int = 250

const PARTY_POS :Vector2 = Vector2(1200,800)
const ITEM_POS :Vector2 = Vector2(195,364)

const fumo_area_scene :PackedScene = preload("res://src/fumo/fumo_area.tscn")
const item_area_scene :PackedScene = preload("res://src/items/item_area.tscn")

@onready var party :Array[Fumo] = GlobalRefs.get_player_party()

var items:Array[Item]

var gold:int:
	set(value):
		gold = value
		%GoldLabel.text = "GOLD: %d" % gold
var overlapping_area:Area2D
var selected_area:Area2D
var original_area_position:Vector2
func _ready() -> void:
	# load in player party
	# load in items
	# load in fumo
	gold = 5
	party = FumoFactory.make_fumos(["marissa","reimu","marissa","reimu","marissa"])
	render_party()
	render_shop_items(get_shop_sizes()[1])
	pass

func render_party() -> void:
	for i in party.size():
		var fumo:Fumo = party[i]
		var fumoArea :FumoArea = fumo_area_scene.instantiate()
		fumoArea.set_fumo(fumo)
		#fumoMap[fumo] = fumoArea

		add_child(fumoArea)
		fumoArea.global_position.x = PARTY_POS.x - (i * FUMO_OFFSET)
		fumoArea.global_position.y = PARTY_POS.y

		fumoArea.mouse_entered.connect(set_overlapping_area.bind(fumoArea))
		fumoArea.mouse_exited.connect(clear_overlapping_area.bind(fumoArea))

func set_overlapping_area(area:Area2D) -> void:
	if selected_area != null:
		if selected_area.is_in_group("fumo") and area.is_in_group("fumo"):
			# switch their positions around

			var area_index:int = party.find(area.fumo)
			var selected_index:int = party.find(selected_area.fumo)
			var temp2:Fumo = party[area_index]
			party[area_index] = party[selected_index]
			party[selected_index] = temp2 
			return_to_position(selected_area)
			return_to_position(area)
		return
	else:
		overlapping_area = area
		if area.is_in_group("fumo") or area.is_in_group("item"):
			area.hover_info.visible = true

func return_to_position(area:Area2D) -> void:
	if area.is_in_group("fumo"):
		area.global_position = Vector2( PARTY_POS.x - (party.find(area.fumo) * FUMO_OFFSET),PARTY_POS.y)

	if area.is_in_group("item"):
		area.global_position = Vector2( ITEM_POS.x + (items.find(area.item) * ITEM_OFFSET),ITEM_POS.y)

func clear_overlapping_area(area:Area2D) -> void:
	if area == selected_area:
		return
	if area.is_in_group("fumo") or area.is_in_group("item"):
		area.hover_info.visible = false
	if area != overlapping_area:
		return
	overlapping_area = null


func render_shop_items(count:int) -> void:
	items = ItemFactory.make_random_items(count,GlobalRefs.teir)
	print(items)

	for i in items.size():
		var item:Item = items[i]
		var itemArea:ItemArea = item_area_scene.instantiate()
		itemArea.set_item(item)

		add_child(itemArea)
		itemArea.global_position.x = ITEM_POS.x + (i * ITEM_OFFSET)
		itemArea.global_position.y = ITEM_POS.y

		itemArea.mouse_entered.connect(set_overlapping_area.bind(itemArea))
		itemArea.mouse_exited.connect(clear_overlapping_area.bind(itemArea))

	pass
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("click") and overlapping_area != null:
		selected_area = overlapping_area
		overlapping_area.global_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("click") and overlapping_area != null:

		# try to buy
		if selected_area.is_in_group("item") and selected_area.get_overlapping_areas().is_empty() == false and selected_area.get_overlapping_areas()[0].is_in_group("fumo"):
			if gold <= selected_area.item.price: 
				print("too poor!")
			else:
				purchase(selected_area,selected_area.get_overlapping_areas()[0])
		
		#fuse fumo
		if selected_area.is_in_group("fumo") and selected_area.get_overlapping_areas().is_empty() == false and selected_area.get_overlapping_areas()[0].is_in_group("fumo"):
			if selected_area.fumo.id == selected_area.get_overlapping_areas()[0].fumo.id:
				merge_fumo(selected_area,selected_area.get_overlapping_areas()[0])
		return_to_position(selected_area)
		selected_area = null

func merge_fumo(mergeeArea:FumoArea,mergerArea:FumoArea) -> void:
	var mergee:Fumo = mergeeArea.fumo
	var merger:Fumo = mergerArea.fumo
	
	var new_atk :int = max(mergee.atk,merger.atk) + 1
	var new_hp :int = max(mergee.hp,merger.hp) + 1
	var new_exp :int = mergee.exp_points + merger.exp_points + 1

	merger.hp = new_hp
	merger.atk = new_atk
	merger.exp_points = new_exp

	remove_party_member(mergeeArea)

func remove_party_member(fumoArea:FumoArea) -> void:
	party.erase(fumoArea.fumo)
	fumoArea.queue_free()
	pass

func purchase(item_bought:ItemArea, buying_fumo:FumoArea) -> void:
	print_debug(item_bought.item.name_str + " bought by " + buying_fumo.fumo.name_str + str(party.find(buying_fumo.fumo)))
	gold -= item_bought.item.price
	item_bought.item.on_sale(buying_fumo.fumo)
	remove_item_area(item_bought)
	pass

func remove_item_area(item_bought:ItemArea) -> void:
	items.erase(item_bought.item)
	item_bought.queue_free()

func get_shop_sizes() -> Array[int]:
	var lvl :int= GlobalRefs.turns
	if lvl > 0 and lvl <= 5:
		return [3,3]
	elif lvl > 3 and lvl <= 5:
		return [4,2]
	elif lvl > 5 and lvl <= 9:
		return [5,2]
	else:
		return [5,2]
