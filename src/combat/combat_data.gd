extends RefCounted
class_name CombatData

var allies:Array[Fumo] = []
var gravyeard:Array[Fumo] = []
var opponents:Array[Fumo]
var feinted_opponents:Array[Fumo] = []
var turn_count: = 0

var ability_queue:Array[AbilityCall]
var spellcard_queue:Array[AbilityCall]

var combat_render:Combat

var summons_negated :bool = false

const SEED_RANGE := 256

enum TEAM {
ALLIES = 1,
OPPONENTS = 2,
}

var team_map := {
TEAM.ALLIES: allies,
TEAM.OPPONENTS: opponents,
}

var opposing_team :={
TEAM.ALLIES: TEAM.OPPONENTS,
TEAM.OPPONENTS: TEAM.ALLIES,
}

var graveyard_map := {
TEAM.ALLIES: gravyeard,
TEAM.OPPONENTS: feinted_opponents,
}

const TEAM_MAX := 6

enum COMBAT_STATE {
	STARTING,
	FIGHTING,
	ENDED,
	}

var seed_value:int

enum RESULTS {
	WIN,
	LOSS,
	DRAW
	}

const ATTACKING_MP_GAIN = 1
const BASE_MP_GAIN = 1

var current_combat_state:COMBAT_STATE = COMBAT_STATE.STARTING

var priority_sort:Callable = func(a1:AbilityCall,a2:AbilityCall) -> bool:
	return a1.fumo.atk > a2.fumo.atk

func get_team(team_id:TEAM) -> Array[Fumo]:
	if team_id == TEAM.ALLIES:
		return allies
	else:
		return opponents

func _init(player_party:Array[Fumo] = []) -> void:

	if player_party.is_empty():
		#allies = _rng_team(TEAM.ALLIES)
		allies = _create_team(["reimu","yumeko","sumireko"],TEAM.ALLIES)
	else:
		allies = set_fumos(player_party,TEAM.ALLIES)
	opponents = _create_team(["youmu","dummyko","dummyko","chiikawa"],TEAM.OPPONENTS)
	#opponents = TeamGenerator.generate_team(TEAM.OPPONENTS)
	

	_generate_seed()
	_start_round()
	pass


func connect_signals(fumo:Fumo) -> void:
	fumo.koed.connect(_on_fumo_ko)
	fumo.changed_order.connect(_on_order_change)
	fumo.summoned_fumo.connect(_summon_fumo)
	fumo.spellcard_ready.connect(_spellcard_ready)
	pass

func _on_order_change() -> void:
	combat_render.rerender_team()

func set_fumos(fumos:Array[Fumo],team_id:TEAM) -> Array[Fumo]:
	for fumo in fumos:
		fumo.team_id = team_id
		connect_signals(fumo)
	return fumos

func set_renderer(parent:Combat) -> void:
	combat_render = parent

func _generate_seed() -> void:
	seed_value = randi_range(0, SEED_RANGE)
	print("Seed is %d" % seed_value)
	seed(seed_value)
	

func _rng_team(team_id:TEAM) -> Array[Fumo]:
	var team :Array[Fumo] = []
	for i in range(TEAM_MAX):
		var random_fumo:String = FumoFactory.FUMOS.pick_random()
		team.append(_make_fumo(random_fumo,team_id))
	return team

func _create_team(team_array:Array[String],team_id:TEAM) -> Array[Fumo]:
	var team :Array[Fumo] = []
	for fumo_str in team_array:
		team.append(_make_fumo(fumo_str,team_id))
	return team

func _make_fumo(fumo_str:String,team_id:TEAM) -> Fumo:
	var fumo := FumoFactory.make_fumo(fumo_str)
	fumo.team_id = team_id
	connect_signals(fumo)
	return fumo


func _on_fumo_ko(fumo:Fumo) -> void:
	#this might lead to problems later...
	await combat_render.animation_over
	combat_render.render_ko(fumo)
	await combat_render.animation_over
	print(fumo.name_str + " was KO'ed")
	_remove_queued_abilities(fumo)
	if fumo.has_method("on_ko"):
		var ability_call := AbilityCall.new()
		ability_call.fumo = fumo
		ability_call.ability = "on_ko"
		ability_queue.push_front(ability_call)

	_swap_fumo(fumo)

	var team :Array[Fumo] = get_team(fumo.team_id)
	var ally_abilities := _get_abilities("on_ally_ko",team)
	ally_abilities.sort_custom(priority_sort)
	ally_abilities.append_array(ability_queue)
	ability_queue = ally_abilities

func _start_round() -> void:
	_print_status()
	current_combat_state = COMBAT_STATE.FIGHTING
	var start_abilities :Array[AbilityCall] = _get_abilities("on_round_start",allies + opponents)
	ability_queue += start_abilities
	
func sannyo_block(team_id:int) -> bool:
	for fumo in get_team(team_id):
		print(fumo.name_str)
		if fumo.name_str == "sannyo" and fumo.ability_uses > 0:
			fumo.ability_uses -= 1
			print('blocked')
			return true
	return false

func _get_abilities(ability_query:StringName,team:Array[Fumo]) -> Array:
	var ability_calls :Array[AbilityCall] = []
	for fumo:Fumo in team:
		var team_id:TEAM = fumo.team_id
		if fumo.has_method(ability_query) and fumo.ability_uses > 0:
			if sannyo_block(opposing_team[team_id]):
				continue		
			var ability_call := AbilityCall.new()
			ability_call.fumo = fumo
			ability_call.ability = ability_query
			ability_calls.append(ability_call)
	ability_calls.sort_custom(priority_sort)
	return ability_calls
	
func _play_ability(ability_call:AbilityCall) -> void:
	var fumo := ability_call.fumo	
	print(ability_call.fumo.name_str + " uses ability: " + ability_call.ability)
	ability_call.fumo.call(ability_call.ability,get_team(fumo.team_id),get_team(opposing_team[fumo.team_id]))

func _play_spellcard(spellcard_call:AbilityCall) -> void:
	var fumo := spellcard_call.fumo
	print(spellcard_call.fumo.name_str + " uses ability: " + spellcard_call.ability)
	if spellcard_call.fumo.id == 002 and fumo.name_str == "Kasen":
		summons_negated = true
		return
	spellcard_call.fumo.call(spellcard_call.ability,get_team(fumo.team_id),get_team(opposing_team[fumo.team_id]))

func append_abilities(queue:Array[AbilityCall]) -> Array[AbilityCall]:
	queue.append_array(ability_queue)
	ability_queue = queue
	return ability_queue

func append_ability(queue:Array[AbilityCall]) -> Array[AbilityCall]:
	queue.append_array(ability_queue)
	ability_queue = queue
	return ability_queue

func _remove_queued_abilities(fumo:Fumo) -> void:
	for ability in ability_queue:
		if ability.fumo == fumo:
			ability_queue.erase(ability)

	for spell in spellcard_queue:
		if spell.fumo == fumo:
			spellcard_queue.erase(spell)

func _playable_ability() -> bool:
	for ability in ability_queue:
		if ability.fumo.status != Fumo.STATUSES.FROZEN:
			return true
	for spell in spellcard_queue:
		if spell.fumo.status != Fumo.STATUSES.FROZEN:
			return true
	return false

func increment_statuses() -> void:
	for ally in allies:		
		ally.remaining_status_time -= 1
	for opp in opponents:		
		opp.remaining_status_time -= 1

func _play_turn() -> void:
	_print_status()
	if _playable_ability():
		if spellcard_queue.size() > 0:
			while spellcard_queue[0].fumo.status == Fumo.STATUSES.FROZEN:
				spellcard_queue.push_back(spellcard_queue.pop_front())
			_play_spellcard(spellcard_queue.pop_front())
			return
		if ability_queue.size() > 0:
			#prevent frozen fumo from using their abilities
			while ability_queue[0].fumo.status == Fumo.STATUSES.FROZEN:
				ability_queue.push_back(ability_queue.pop_front())
			_play_ability(ability_queue.pop_front())
			return
	else:
	
		var all_turn_abilities := _get_abilities("on_turn_start",allies)
		var opp_turn_abilities := _get_abilities("on_turn_start",opponents)
		all_turn_abilities.append_array(opp_turn_abilities)
		all_turn_abilities.sort_custom(priority_sort)
		append_abilities(all_turn_abilities)

		if (allies.size() == 0 or opponents.size() == 0):
			round_over()
			
			return

		#smthn turn based
		var front_ally:Fumo = allies[0]
		var front_opp:Fumo = opponents[0]


		#animate them smashing into each other.
		_fight(front_ally,front_opp)
		increment_mp(front_ally,front_opp)
		increment_statuses()

		if front_ally.hp == 0:
			if allies.size() < 0:
				front_ally =_swap_fumo(allies[0])

		if front_opp.hp == 0:
			if opponents.size() < 0:
				front_opp = _swap_fumo(opponents[0])

		turn_count += 1
		print("Turn Over")

func increment_mp(front_ally:Fumo, front_opp:Fumo) -> void:
	front_ally.mp += ATTACKING_MP_GAIN
	front_opp.mp += ATTACKING_MP_GAIN
	for ally in allies:
		ally.mp += BASE_MP_GAIN

	for opp in opponents:
		if opp.id == 003:
			print_debug(opp.mp, opp.used_spellcard)
			opp.mp += BASE_MP_GAIN
			print_debug(opp.mp)
		else:
			opp.mp += BASE_MP_GAIN

func _summon_fumo(fumo:Fumo,team_id:TEAM) -> void:
	if did_kasen_block(team_id):
		return
	connect_signals(fumo)
	fumo.team_id = team_id
	team_map[team_id] = _add_to_team(fumo)
	combat_render.slide_team(team_map[team_id].slice(1),-1)
	combat_render.render_summon(fumo)


	for opp:Fumo in team_map[opposing_team[fumo.team_id]]:
		if opp.has_method("on_opponent_summon"):
			var ability_call := AbilityCall.new()
			ability_call.fumo = opp
			ability_call.ability = "on_opponent_summon"
			ability_queue.push_front(ability_call)
	
	pass

func did_kasen_block(team_id:TEAM) -> bool:
	if summons_negated:
		print("summons_negated")
		return true
	for opp:Fumo in get_team(opposing_team[team_id]):
		if opp.id == 002 and opp.name_str == "Kasen" and opp.ability_uses > 0:
			opp.ability_uses -= 1
			print("blocked by kasen!")
			return true
	return false

func _add_to_team(fumo:Fumo) -> Array[Fumo]:
	var team:Array[Fumo] = get_team(fumo.team_id)
	if team.size() < TEAM_MAX or fumo.is_subtitution:
		team.push_front(fumo)
		combat_render.add_fumo_area(fumo)
	return team

func _fight(ally:Fumo,opponent:Fumo) -> void:
	#smash each other
	combat_render.render_fight(ally, opponent)
	await combat_render.animation_over
	ally.hp -= _calculate_damage(opponent)
	opponent.hp -= _calculate_damage(ally)
	combat_render.render_fight_return(ally, opponent)
	await combat_render.animation_over
	

static func _calculate_damage(fumo:Fumo) -> int:
	if fumo.status == Fumo.STATUSES.BLIND:
		fumo.set_status(Fumo.STATUSES.NORMAL,-1)
		return 0
	return fumo.atk

static func deal_damage(fumo:Fumo,damage:int) -> void:
	fumo.hp -= damage
	pass

func _swap_fumo(fumo:Fumo) -> Fumo:
	var team :Array[Fumo]= get_team(fumo.team_id)
	var graveyard:Array[Fumo] = graveyard_map[fumo.team_id]
	graveyard.append(fumo)
	team.erase(fumo)
	combat_render.remove_fumo_area(fumo)
	combat_render.slide_team(team,1)
	if team.is_empty():
		return null
	else:
		return team[0]

# if jasmine = coooll
# 	return: "slay!"
	
func round_over() -> void:
	print_debug(allies.size(),opponents.size())
	current_combat_state = COMBAT_STATE.ENDED
	if allies.size() > 0 and opponents.size() == 0:
		print('player won')
		GlobalRefs.battle_ended(RESULTS.WIN)
	if opponents.size() > 0 and allies.size() == 0:
		print('player lost')
		GlobalRefs.battle_ended(RESULTS.LOSS)
	else:
		print('draw')
		GlobalRefs.battle_ended(RESULTS.DRAW)

func _use_ability(ability:Callable) -> void:
	ability.call(allies,opponents)

func _spellcard_ready(fumo:Fumo) -> void:
	var spell_call :AbilityCall = AbilityCall.new()
	spell_call.fumo = fumo
	spell_call.ability = "spellcard"
	spellcard_queue.append(spell_call)
	spellcard_queue.sort_custom(priority_sort)
	print(spellcard_queue)
	
	pass

func _print_status() -> void:
	print("---TURN:" + str(turn_count) + "---")
	print("SPELL_QUEUE")
	print(spellcard_queue)
	print("ABILITY_QUEUE")
	print(ability_queue)
	print("ALLIES:")
	for i in range(allies.size()):
		print(str(i) + ": "+allies[i]._to_string())
	print("OPPONENTS:")
	for i in range(opponents.size()):
		print(str(i) + ": "+opponents[i]._to_string())
