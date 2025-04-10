extends Node

# enum FUMOS {
# 	CIRNO,
# 	SHINMYOUMARU,
# 	KASEN,
# 	CHIIKAWA,
# 	SUMIREKO,
# 	YOUMU,
# 	RUMIA,
# 	SANAE,
# 	SANNYO,
# 	REIMU,
# 	MARISSA,
# 	YUMEKO,
# 	CLOWNPIECE,
# 	GENGETSU,
# 	KOISHI,
# 	AUNN,
# 	YUMEMI,
# 	SEIGA,
# 	HINA,
# 	YUUKA,
# 	YUKARI,
# 	SAKUYA,
# 	MIMA,
# 	MOKOU,
# }
#
const FUMOS: Array[String] = [
	"marissa",
	"reimu",
	"sumireko",
	"sakuya",
	"kasen",
	"dummyko",
]

const fumoAreaScene = preload("res://src/fumo/fumo_area.tscn")

static func make_fumo_area(fumo_name:String) -> FumoArea:
	var fumo_data:Script = load("res://src/fumo/" + fumo_name + ".gd")
	var fumoArea:FumoArea = fumoAreaScene.instantiate()	
	fumoArea.fumo = Fumo.new()
	fumoArea.fumo.set_script(fumo_data)
	return fumoArea

static func make_fumo(fumo_name:String) -> Fumo:
	var fumo_data:Script = load("res://src/fumo/" + fumo_name + ".gd")
	var fumo := Fumo.new()
	fumo.set_script(fumo_data)
	return fumo

static func make_fumos(fumo_names:Array[String]) -> Array[Fumo]:	
	var test_party:Array[Fumo] = []
	for fumo_str in fumo_names:
		test_party.append(make_fumo(fumo_str))
	return test_party


static func make_random_fumos(count:int, max_tier:int) -> Array:
	print_debug(max_tier)
	var fumos:Array[Fumo] = []
	while fumos.size() < count:
		var fumo_str:String = FUMOS.pick_random()
		var fumo_data:Script = load("res://src/fumo/" + fumo_str + ".gd")
		var fumo := Fumo.new()
		fumo.set_script(fumo_data)
		if fumo.tier <= max_tier:
			fumos.append(fumo)
	print_debug(fumos)
	return fumos
	
