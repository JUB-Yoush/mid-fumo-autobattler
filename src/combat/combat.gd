extends Node
class_name Combat

var combat_data :CombatData

var fumoAreaScene:PackedScene = preload("res://src/fumo/fumo_area.tscn")

var allyAreas:Array[FumoArea]
var opponentAreas:Array[FumoArea]

const FUMO_OFFSET:int = 125
const SCREEN_CENTER:int = 1920/2

@onready var allyNode :Node2D = $Allies
@onready var opponentNode :Node2D = $Opponents

signal animation_over

var fumoMap:Dictionary[Fumo,FumoArea]

func _ready() -> void:
	_start_combat()


func _start_combat() -> void:
	combat_data = CombatData.new()
	combat_data.set_renderer(self)
	render_team()

func remove_fumo_area(fumo:Fumo) -> void:
	fumo.area.queue_free()
	#fumoMap.erase(fumo)

	pass

func add_fumo_area(fumo:Fumo) -> void:
	if fumo.team_id == CombatData.TEAM.ALLIES:
		var fumoArea :FumoArea = fumoAreaScene.instantiate()
		fumoArea.set_fumo(fumo)
		allyNode.add_child(fumoArea)
		fumoArea.position.x = SCREEN_CENTER - (1 * FUMO_OFFSET)
		fumoArea.position.y = 1080/2
	else:
		var fumoArea :FumoArea = fumoAreaScene.instantiate()
		fumoArea.set_fumo(fumo)
		opponentNode.add_child(fumoArea)
		fumoArea.position.x = SCREEN_CENTER + (1 * FUMO_OFFSET)
		fumoArea.position.y = 1080/2


func render_team() -> void:
	for fumo:Fumo in combat_data.allies:
		var fumoArea :FumoArea = fumoAreaScene.instantiate()
		fumoArea.set_fumo(fumo)
		allyNode.add_child(fumoArea)
		fumoArea.position.x = SCREEN_CENTER - (allyNode.get_child_count() * FUMO_OFFSET)
		fumoArea.position.y = 1080/2

	for fumo:Fumo in combat_data.opponents:
		var fumoArea :FumoArea = fumoAreaScene.instantiate()
		fumoArea.set_fumo(fumo)
		opponentNode.add_child(fumoArea)
		fumoArea.position.x = SCREEN_CENTER + (opponentNode.get_child_count() * FUMO_OFFSET)
		fumoArea.position.y = 1080/2


func render_fight(ally:Fumo, opponent:Fumo) -> void:
	# these need to be tween based and not use anim players
	#fumoMap[ally].animPlayer.play("ally_hit")
	ally.area.animPlayer.play("ally_hit")
	opponent.area.animPlayer.play("opponent_hit")
	await get_tree().create_timer(1).timeout
	animation_over.emit()

func render_ko(fumo:Fumo) -> void:
	# fly away now
	if fumo.id == CombatData.TEAM.ALLIES:
		fumo.area.animPlayer.play("ko")
	else:
		fumo.area.animPlayer.play("ko")
	await get_tree().create_timer(1).timeout
	animation_over.emit()

func render_die(fumo:Fumo) -> void:
	# fly away now
	pass

func render_summon(fumo:Fumo) -> void:
	fumo.area.animPlayer.play("summon")
	await get_tree().create_timer(.5).timeout
	animation_over.emit()

func win() -> void:
	pass

func draw() -> void:
	pass

func lose() -> void:
	pass

#debug
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_turn") and combat_data.current_combat_state == CombatData.COMBAT_STATE.FIGHTING:
		combat_data._play_turn()

func _print_status() -> void:
	print("---TURN:" + str(combat_data.turn_count) + "---")
	print("ABILITY_QUEUE")
	print(combat_data.ability_queue)
	print("ALLIES:")
	for i in range(combat_data.allies.size()):
		print(str(i) + ": "+ combat_data.allies[i]._to_string())
	print("OPPONENTS:")
	for i in range(combat_data.opponents.size()):
		print(str(i) + ": "+combat_data.opponents[i]._to_string())
