extends Node

var fumoMap:Dictionary[Fumo,FumoArea]

const ITEM_OFFSET:int = 150
const FUMO_OFFSET:int = 250

const PARTY_POS :Vector2 = Vector2(1200,850)
const SHOPMO_POS :Vector2 = Vector2(1200,500)
const ITEM_POS :Vector2 = Vector2(1200,250)

@onready var fumo_area_scene :PackedScene= load("res://src/fumo/fumo_area.tscn")
@onready var item_area_scene :PackedScene= load("res://src/items/item_area.tscn")

@onready var party :Array[Fumo] = GlobalRefs.get_player_party()

@onready var buyArea:Area2D = $BuyArea
@onready var sellArea:Area2D = $SellArea
@onready var freezeArea:Area2D = $FreezeArea
@onready var rollBtn:Button = $RollButton
@onready var endBtn:Button = $EndButton

var items:Array[Item]
var shop_fumos:Array[Fumo]

var fumo_in_buyarea:FumoArea
var fumo_in_sellarea:FumoArea
var fumo_in_freezearea:Area2D

var gold:int:
	set(value):
		gold = value
		%GoldLabel.text = "%d" % gold
var overlapping_area:Area2D
var selected_area:Area2D
var original_area_position:Vector2

func _ready() -> void:
	AudioManager.play_music(preload("res://assets/music/menu.ogg"))
	buyArea.area_entered.connect(
		func(area:Area2D) -> void:
		if area.is_in_group("shop_fumo"):
			fumo_in_buyarea = area	
	)

	sellArea.area_entered.connect(
		func(area:Area2D) -> void:
		if area.is_in_group("party"):
			fumo_in_sellarea = area	
	)

	freezeArea.area_entered.connect(
		func(area:Area2D) -> void:
		if area.is_in_group("interactable"):
			fumo_in_freezearea = area	
	)

	buyArea.area_exited.connect(_shop_area_exited)
	sellArea.area_exited.connect(_shop_area_exited)
	freezeArea.area_exited.connect(_shop_area_exited)

	rollBtn.pressed.connect(shuffle_shop)
	endBtn.pressed.connect(end_shop_turn)

	gold = 10
	party = GlobalRefs.get_player_party()
	print(party)
	render_party()
	render_shop_items(get_shop_sizes()[1])
	render_shop_fumos(get_shop_sizes()[0])
	set_ui_elements()

func set_ui_elements() -> void:
	%TurnsLabel.text = str(GlobalRefs.turns)
	%WinLabel.text = "%d/%d" % [GlobalRefs.wins,GlobalRefs.WIN_REQUIREMENT]
	%LossesLabel.text = "%d/%d" % [GlobalRefs.losses,GlobalRefs.LOSS_REQUIREMENT]

func shuffle_shop() -> void:
	if gold < 1:
		return
	gold -= 1
	var frozen_items:Array[Item] = []
	var frozen_fumos:Array[Fumo] = []

	while not items.is_empty():
		var item:Item = items[0]
		if item.area.frozen:
			frozen_items.append(item)
		remove_item_area(item.area)

	while not shop_fumos.is_empty():
		var fumo:Fumo = shop_fumos[0]
		if fumo.area.frozen:
			frozen_fumos.append(fumo)
		remove_fumo_area(fumo.area)

	var new_fumos:Array[Fumo] = FumoFactory.make_random_fumos(get_shop_sizes()[0] - frozen_fumos.size(),GlobalRefs.tier)
	print_debug(frozen_fumos)
	print_debug(new_fumos)

	for fumo in frozen_fumos:
		new_fumos.append(fumo)

	shop_fumos = new_fumos

	for i in shop_fumos.size():
		render_shop_fumo(i)

	var new_items:Array[Item] = ItemFactory.make_random_items(get_shop_sizes()[1] - frozen_items.size(),GlobalRefs.tier)
	print_debug(frozen_items)
	print_debug(new_items)

	for item in frozen_items:
		new_items.append(item)

	items = new_items

	for i in items.size():
		render_shop_item(i)

func render_party_fumo(index:int) -> void:
	var fumo:Fumo = party[index]
	print(fumo_area_scene.can_instantiate())
	var fumoArea :FumoArea = fumo_area_scene.instantiate()
	fumoArea.set_fumo(fumo)
	add_child(fumoArea)
	fumoArea.add_to_group("party")
	fumoArea.add_to_group("interactable")
	return_to_position(fumoArea)

	fumoArea.mouse_entered.connect(set_overlapping_area.bind(fumoArea))
	fumoArea.mouse_exited.connect(clear_overlapping_area.bind(fumoArea))

func render_shop_fumo(index:int, frozen:bool = false) -> void:
	var fumo:Fumo = shop_fumos[index]
	var fumoArea:FumoArea = fumo_area_scene.instantiate()
	fumoArea.set_fumo(fumo)
	fumoArea.in_shop = true

	add_child(fumoArea)
	fumoArea.add_to_group("interactable")
	fumoArea.add_to_group("shop_fumo")
	fumoArea.frozen = frozen

	return_to_position(fumoArea)

	fumoArea.mouse_entered.connect(set_overlapping_area.bind(fumoArea))
	fumoArea.mouse_exited.connect(clear_overlapping_area.bind(fumoArea))

func render_shop_item(index:int) -> void:
	var item:Item = items[index]
	var itemArea:ItemArea = item_area_scene.instantiate()
	itemArea.set_item(item)

	add_child(itemArea)

	itemArea.add_to_group("interactable")

	return_to_position(itemArea)

	itemArea.mouse_entered.connect(set_overlapping_area.bind(itemArea))
	itemArea.mouse_exited.connect(clear_overlapping_area.bind(itemArea))

func render_shop_fumos(count:int) -> void:
	var frozen_fumo: Array[Fumo] = GlobalRefs.get_frozen_shop()[0]
	shop_fumos = FumoFactory.make_random_fumos(count - frozen_fumo.size(),GlobalRefs.tier)
	print_debug(frozen_fumo)
	shop_fumos.append_array(frozen_fumo)
	for i in shop_fumos.size():
		render_shop_fumo(i)

func render_party() -> void:
	for i in party.size():
		render_party_fumo(i)

func render_shop_items(count:int) -> void:
	var frozen_items: Array[Item] = GlobalRefs.get_frozen_shop()[1]
	print_debug(frozen_items)
	items = ItemFactory.make_random_items(count - frozen_items.size(),GlobalRefs.tier)
	items.append_array(frozen_items)
	for i in items.size():
		render_shop_item(i)

func set_overlapping_area(area:Area2D) -> void:
	if selected_area != null:
		if selected_area.is_in_group("party") and area.is_in_group("party"):
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
		#if area.is_in_group("party") or area.is_in_group("item"):
		area.hover_info.visible = true

func return_to_position(area:Area2D) -> void:
	if area.is_in_group("party"):
		area.global_position = Vector2( PARTY_POS.x - (party.find(area.fumo) * FUMO_OFFSET),PARTY_POS.y)
		return

	if area.is_in_group("item"):
		area.global_position = Vector2( ITEM_POS.x - (items.find(area.item) * ITEM_OFFSET),ITEM_POS.y)
		return

	if area.is_in_group("shop_fumo"):
		area.global_position = Vector2( SHOPMO_POS.x - (shop_fumos.find(area.fumo) * FUMO_OFFSET),SHOPMO_POS.y)
		return

func clear_overlapping_area(area:Area2D) -> void:
	if area == selected_area:
		return
		#if area.is_in_group("party") or area.is_in_group("item"):
	area.hover_info.visible = false
	if area != overlapping_area:
		return
	overlapping_area = null

func check_for_areas() -> void:
	#fixes entering exiting issue
	if buyArea.get_overlapping_areas().is_empty() == false:
		if buyArea.get_overlapping_areas()[0].is_in_group("shop_fumos"):
			fumo_in_buyarea = buyArea.get_overlapping_areas()[0]
		
	if sellArea.get_overlapping_areas().is_empty() == false:
		if sellArea.get_overlapping_areas()[0].is_in_group("party"):
			fumo_in_sellarea = sellArea.get_overlapping_areas()[0]

	if freezeArea.get_overlapping_areas().is_empty() == false:
		if freezeArea.get_overlapping_areas()[0].is_in_group("interactable"):
			fumo_in_freezearea = freezeArea.get_overlapping_areas()[0]
	pass
func _process(delta: float) -> void:
	check_for_areas()
	if Input.is_action_pressed("click") and overlapping_area != null:
		selected_area = overlapping_area
		overlapping_area.global_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("click") and overlapping_area != null:
		# try to buy
		if selected_area.is_in_group("item") and selected_area.get_overlapping_areas().is_empty() == false and selected_area.get_overlapping_areas()[0].is_in_group("party"):
			if gold < selected_area.item.price: 
				print("too poor!")
			else:
				purchase(selected_area,selected_area.get_overlapping_areas()[0])
		
		#fuse fumo
		if selected_area.is_in_group("party") and selected_area.get_overlapping_areas().is_empty() == false and selected_area.get_overlapping_areas()[0].is_in_group("party"):
			if selected_area.fumo.id == selected_area.get_overlapping_areas()[0].fumo.id:
				merge_fumo(selected_area,selected_area.get_overlapping_areas()[0],true)
		
		#print(selected_area.is_in_group("shop_fumos"), selected_area.get_overlapping_areas().is_empty() == false, selected_area.get_overlapping_areas()[0].is_in_group("party"))
		if selected_area.is_in_group("shop_fumo") and selected_area.get_overlapping_areas().is_empty() == false and selected_area.get_overlapping_areas()[0].is_in_group("party"):
			if selected_area.fumo.id == selected_area.get_overlapping_areas()[0].fumo.id and gold >=selected_area.fumo.price:
				merge_fumo(selected_area,selected_area.get_overlapping_areas()[0],false)


		return_to_position(selected_area)
		selected_area = null

	if Input.is_action_just_released("click"): 
		print(fumo_in_buyarea,fumo_in_sellarea,fumo_in_freezearea)
		if fumo_in_buyarea != null:
			purchase_fumo(fumo_in_buyarea)
		elif fumo_in_sellarea != null:
			sell_fumo(fumo_in_sellarea)
		elif fumo_in_freezearea != null:
			freeze_shopitem(fumo_in_freezearea)

func purchase_fumo(fumoArea:FumoArea) -> void:
	if party.size() >= GlobalRefs.TEAM_LIMIT or gold < GlobalRefs.FUMO_PRICE:
		return
	gold -= GlobalRefs.FUMO_PRICE
	fumoArea.in_shop = false
	fumoArea.frozen = false
	fumoArea.remove_from_group("shop_fumo")
	fumoArea.add_to_group("party")
	party.append(fumoArea.fumo)
	shop_fumos.erase(fumoArea.fumo)
	for others in party:
		return_to_position(others.area)
	#return_to_position(fumoArea)

func sell_fumo(fumoArea:FumoArea) -> void:
	if not fumoArea.is_in_group("party"):
		return
	gold += fumoArea.fumo.level + 1
	remove_party_member(fumoArea)
	pass

func freeze_shopitem(shopItem:Area2D) -> void:
	if shopItem.is_in_group("party"):
		return

	shopItem.frozen = !shopItem.frozen

func merge_fumo(mergeeArea:FumoArea,mergerArea:FumoArea,in_party:bool = false) -> void:
	var mergee:Fumo = mergeeArea.fumo
	var merger:Fumo = mergerArea.fumo
	
	var new_atk :int = max(mergee.atk,merger.atk) + 1
	var new_hp :int = max(mergee.hp,merger.hp) + 1
	var new_exp :int = mergee.exp_points + merger.exp_points + 1

	merger.hp = new_hp
	merger.atk = new_atk
	merger.exp_points = new_exp
	if in_party:
		remove_party_member(mergeeArea)
	else:
		remove_fumo_area(mergeeArea)
		gold -= 3
	return_to_position(mergerArea)


func purchase(item_bought:ItemArea, buying_fumo:FumoArea) -> void:
	print_debug(item_bought.item.name_str + " bought by " + buying_fumo.fumo.name_str + str(party.find(buying_fumo.fumo)))
	gold -= item_bought.item.price
	item_bought.item.on_sale(buying_fumo.fumo)
	remove_item_area(item_bought)
	pass

func remove_party_member(fumoArea:FumoArea) -> void:
	#party[party.find(fumoArea.fumo)] = null
	party.erase(fumoArea.fumo)
	fumoArea.queue_free()
	for others in party:
		return_to_position(others.area)

func remove_item_area(item_bought:ItemArea) -> void:
	items.erase(item_bought.item)
	item_bought.queue_free()

func remove_fumo_area(fumoArea:FumoArea) -> void:
	shop_fumos.erase(fumoArea.fumo)
	fumoArea.queue_free()
	for others in shop_fumos:
		return_to_position(others.area)

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


func _shop_area_exited(area:Area2D) -> void:
	if fumo_in_buyarea == area:
		fumo_in_buyarea = null

	if fumo_in_sellarea == area:
		fumo_in_sellarea = null

	if fumo_in_freezearea == area:
		fumo_in_freezearea = null

func get_frozen_fumos() -> Array[Fumo]:
	var frozen_fumos :Array[Fumo] = []
	for fumo:Fumo in shop_fumos:
		if fumo.area.frozen:
			frozen_fumos.append(fumo)
	return frozen_fumos
			

func get_frozen_items() -> Array[Item]:
	var frozen_items :Array[Item] = []
	for item:Item in items:
		if item.area.frozen:
			frozen_items.append(items)
	return frozen_items

func end_shop_turn() -> void:
	# make a copy of the team, pass that into globalRefs
	# unset all their areas?
	# globalRefs uses that to play the battle
	# once battle ends, return to shop.
	print_debug(party, "APSDOAJEPWOADPOISDJFPAOIWERJAOPIEJ")
	GlobalRefs.set_player_party(party)
	GlobalRefs.set_frozen_shop(get_frozen_fumos(),get_frozen_items())	
	GlobalRefs.start_battle()
	pass
