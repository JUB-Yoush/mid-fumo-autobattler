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
