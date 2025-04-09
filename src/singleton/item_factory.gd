extends Node
class_name ItemFactory

enum ITEM_TYPES {
	FUMO,
	ITEM,
}


const ITEMS: Array[String] = [
"White Bread"
]


static func make_item(item_name:String) -> Item:
	var item_data:Script = load("res://src/items/" + item_name + ".gd")
	var item := Item.new()
	item.set_script(item_data)
	return item

static func make_random_items(item_count:int, max_tier:int) -> Array:
	var items:Array[Item] = []
	for i in item_count:
		var rng :int = randi_range(0, ITEMS.size())
		var item_data:Script = load("res://src/items/" + ITEMS[rng] + ".gd")
		var item := Item.new()
		item.set_script(item_data)
		items.append(item)
	print(items)
	return items
	
