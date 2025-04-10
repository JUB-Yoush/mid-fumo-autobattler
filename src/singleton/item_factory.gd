extends Node
class_name ItemFactory

enum ITEM_TYPES {
	FUMO,
	ITEM,
}


const ITEMS: Array[String] = [
"white_bread",
"orb"
]


static func make_item(item_name:String) -> Item:
	var item_data:Script = load("res://src/items/" + item_name + ".gd")
	var item := Item.new()
	item.set_script(item_data)
	return item

static func make_random_items(item_count:int, max_tier:int) -> Array:
	var items:Array[Item] = []
	for i in item_count:
		var item_str:String = ITEMS.pick_random()
		var item_data:Script = load("res://src/items/" + item_str + ".gd")
		var item := Item.new()
		item.set_script(item_data)
		items.append(item)
	print(items)
	return items
	
