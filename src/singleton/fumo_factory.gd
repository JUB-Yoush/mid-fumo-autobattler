extends Node

enum FUMOS {
	CIRNO,
	SHINMYOUMARU,
	KASEN,
	CHIIKAWA,
	SUMIREKO,
	YOUMU,
	RUMIA,
	SANAE,
	SANNYO,
	REIMU,
	MARISSA,
	YUMEKO,
	CLOWNPIECE,
	GENGETSU,
	KOISHI,
	AUNN,
	YUMEMI,
	SEIGA,
	HINA,
	YUUKA,
	YUKARI,
	SAKUYA,
	MIMA,
	MOKOU,
}

const fumoAreaScene = preload("res://src/fumo/fumo_area.tscn")


static func make_fumo(fumo_name) -> FumoArea:
	var fumo_data = load("res://src/fumo/" + fumo_name + ".gd")
	var fumoArea:FumoArea = fumoAreaScene.instantiate()	
	fumoArea.fumo = Fumo.new()
	fumoArea.fumo.set_script(fumo_data)
	return fumoArea
