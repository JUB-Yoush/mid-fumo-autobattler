extends RefCounted
class_name Item

var area:ItemArea
var id:int
var name_str:String
var ability_desc:String
var image:Texture2D
var price:int = 3
var tier:int

func _to_string() -> String:
	return name_str
