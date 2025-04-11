extends Node
class_name Combat

var combat_data :CombatData

var fumoAreaScene:PackedScene = preload("res://src/fumo/fumo_area.tscn")

var allyAreas:Array[FumoArea]
var opponentAreas:Array[FumoArea]

const FUMO_OFFSET:int = 125
const SMACK_DIST :int = 125
const SCREEN_CENTER:int = 1920/2
var anim_speed :float= .5
var attack_anim_speed :float= .3
const ANIM_SPEEDS:Array[float] = [.25,.5, 1]

@onready var allyNode :Node2D = $Allies
@onready var opponentNode :Node2D = $Opponents

signal animation_over

var fumoMap:Dictionary[Fumo,FumoArea]

var dir_map:Dictionary = {CombatData.TEAM.ALLIES:1}

func _ready() -> void:
	_start_combat()


func _start_combat() -> void:
	combat_data = CombatData.new(GlobalRefs.get_battle_party())
	combat_data.set_renderer(self)
	render_team()

func remove_fumo_area(fumo:Fumo) -> void:
	fumo.area.queue_free()

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
	var tween:Tween = create_tween()
	tween.set_parallel(true)
	var allyArea:FumoArea = ally.area
	var oppArea:FumoArea = opponent.area
	tween.tween_property(allyArea, "position",Vector2(allyArea.position.x +(FUMO_OFFSET),allyArea.position.y),attack_anim_speed)
	tween.tween_property(oppArea, "position",Vector2(oppArea.position.x -(FUMO_OFFSET),oppArea.position.y),attack_anim_speed)
	await tween.finished
	animation_over.emit()

func render_fight_return(ally:Fumo, opponent:Fumo) -> void:
	var tween:Tween = create_tween()
	tween.set_parallel(true)
	var allyArea:FumoArea = ally.area
	var oppArea:FumoArea = opponent.area
	tween.tween_property(allyArea, "position",Vector2(allyArea.position.x -(FUMO_OFFSET),allyArea.position.y),attack_anim_speed)
	tween.tween_property(oppArea, "position",Vector2(oppArea.position.x +(FUMO_OFFSET),oppArea.position.y),attack_anim_speed)
	await tween.finished
	animation_over.emit()
	pass

func render_ko(fumo:Fumo) -> void:
	# fly away now
	var tween:Tween = create_tween()
	tween.set_parallel(true)
	var fumoArea:FumoArea = fumo.area
	var team_dir:int = 1 if fumo.team_id == CombatData.TEAM.ALLIES else -1
	tween.tween_property(fumoArea, "position",Vector2(fumoArea.position.x - (FUMO_OFFSET * team_dir) ,get_viewport().get_visible_rect().size.y),anim_speed)
	await tween.finished
	animation_over.emit()

func render_die(fumo:Fumo) -> void:
	# fly away now
	pass

func render_summon(fumo:Fumo) -> void:
	fumo.area.animPlayer.play("summon")
	await get_tree().create_timer(.5).timeout
	animation_over.emit()
	# var tween:Tween = create_tween()
	# tween.set_parallel(true)
	# var fumoArea:FumoArea = fumo.area
	# var team_dir:int = 1 if fumo.team_id == CombatData.TEAM.ALLIES else -1
	# fumoArea.scale = Vector2.ZERO
	# tween.tween_property(fumoArea, "scale",Vector2(0.5,0.5),anim_speed)
	# await tween.finished
	# animation_over.emit()

func slide_team(team:Array[Fumo],dir:int) -> void:
	# a up   1 1 = 1
	# a down 1 -1 = -1
	# o up   -1 1 = -1
	# o down -1 -1 = 1
	if team.size() == 0:
		animation_over.emit()
		return
	var tween:Tween = create_tween()
	tween.set_parallel(true)
	for fumo:Fumo in team:
		var fumoArea:FumoArea = fumo.area
		var team_dir:int = 1 if fumo.team_id == CombatData.TEAM.ALLIES else -1
		tween.tween_property(fumoArea, "position",Vector2(fumoArea.position.x +(FUMO_OFFSET * dir * team_dir),fumoArea.position.y),anim_speed)
	await tween.finished
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
