extends Resource
class_name AbilityCall

var fumo:Fumo
var ability:StringName


func _to_string() -> String:
	return fumo.name_str + "|" + ability +"\n"
