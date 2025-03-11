extends Node2D
class_name Combat

var allies:Array[Fumo] = []
var gravyeard:Array[Fumo] = []
var opponents:Array[Fumo]
var feinted_opponents:Array[Fumo] = []
var turn_count: = 0
# signal turn_started
# signal turn_ended
# signal ally_feinted
# signal opponent_feinted
# signal spell_casted
# signal damage_taken
# signal fumo_summoned

var ability_queue:Array[AbilityCall]
var spell_queue:Array[AbilityCall]

const SEED_RANGE := 256

enum TEAM {
ALLIES,
OPPONENTS,
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

var current_combat_state:COMBAT_STATE = COMBAT_STATE.STARTING

var priority_sort:Callable = func(a1:AbilityCall,a2:AbilityCall) -> bool:
	return a1.fumo.atk > a2.fumo.atk

func get_team(team_id:TEAM) -> Array[Fumo]:
	if team_id == TEAM.ALLIES:
		return allies
	else:
		return opponents
	

func _ready() -> void:
	# allies = _generate_team()
	# opponents = _generate_team()
	allies = _create_team(['reimu','reimu','reimu','reimu','reimu','reimu'], TEAM.ALLIES)
	opponents = _create_team(['sumireko','sakuya','sumireko','sumireko','sumireko','sumireko'],TEAM.OPPONENTS)
	_generate_seed()
	_start_round()
	pass

func _generate_seed() -> void:
	seed_value = randi_range(-SEED_RANGE, SEED_RANGE)
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
	fumo.koed.connect(_on_fumo_ko)
	return fumo


func _on_fumo_ko(fumo:Fumo) -> void:
	print(fumo.name_str + " was KO'ed")
	_remove_queued_abilities(fumo)
	if fumo.has_method("on_ko"):
		var ability_call := AbilityCall.new()
		ability_call.fumo = fumo
		ability_call.ability = "on_ko"
		ability_queue.push_front(ability_call)

	_swap_fumo(fumo)

	var team := get_team(fumo.team_id)
	var ally_abilities := _get_abilities("on_ally_ko",team)
	ally_abilities.sort_custom(priority_sort)
	ally_abilities.append_array(ability_queue)
	ability_queue = ally_abilities

func _start_round() -> void:
	_print_status()
	current_combat_state = COMBAT_STATE.FIGHTING
	var start_abilities :Array[AbilityCall] = _get_abilities("on_round_start",allies + opponents)
	ability_queue += start_abilities
	

func _get_abilities(ability_query:StringName,team:Array[Fumo]) -> Array:
	var ability_calls :Array[AbilityCall] = []
	for fumo:Fumo in team:
		if fumo.has_method(ability_query):
			var ability_call := AbilityCall.new()
			ability_call.fumo = fumo
			ability_call.ability = ability_query
			ability_calls.append(ability_call)
	ability_calls.sort_custom(priority_sort)
	return ability_calls
	
func _play_ability(ability_call:AbilityCall) -> void:
	var fumo := ability_call.fumo	
	print(ability_call.fumo.name_str + " uses ability: " + ability_call.ability)
	#ability_call.fumo.call(ability_call.ability,team_map[fumo.team_id],team_map[opposing_team[fumo.team_id]])
	ability_call.fumo.call(ability_call.ability,get_team(fumo.team_id),get_team(opposing_team[fumo.team_id]))

func append_abilities(queue:Array[AbilityCall]) -> Array[AbilityCall]:
	queue.append_array(ability_queue)
	ability_queue = queue
	return ability_queue

func _remove_queued_abilities(fumo:Fumo) -> void:
	for ability in ability_queue:
		if ability.fumo == fumo:
			ability_queue.erase(ability)

func _play_turn() -> void:
	_print_status()
	if ability_queue.size() > 0:
		_play_ability(ability_queue.pop_front())
		return
	
	var all_turn_abilities := _get_abilities("on_turn_start",allies)
	var opp_turn_abilities := _get_abilities("on_turn_start",opponents)
	all_turn_abilities.append_array(opp_turn_abilities)
	all_turn_abilities.sort_custom(priority_sort)
	append_abilities(all_turn_abilities)

	#smthn turn based
	var front_ally:Fumo = allies[0]
	var front_opp:Fumo = opponents[0]
	#animate them smashing into each other.
	_fight(front_ally,front_opp)

	if front_ally.hp == 0:
		gravyeard.append(allies.pop_front())
		#print(front_ally.name_str + " was KO'ed")
		if allies.size() < 0:
			front_ally =_swap_fumo(allies[0])

	if front_opp.hp == 0:
		feinted_opponents.append(opponents.pop_front())
		#print(front_opp.name_str + " was KO'ed")
		if opponents.size() < 0:
			front_opp = _swap_fumo(opponents[0])

	if (allies.size() == 0 or opponents.size() == 0):
		round_over()
	turn_count += 1
	print("Turn Over")

func summon_fumo(fumo:Fumo) -> void:
	var team:Array[Fumo] = get_team(fumo.team_id)
	if team.size() < TEAM_MAX:
		team.push_front(fumo)

static func _fight(ally:Fumo,opponent:Fumo) -> void:
	#smash each other
	ally.hp -= _calculate_damage(opponent)
	opponent.hp -= _calculate_damage(ally)

static func _calculate_damage(fumo:Fumo) -> int:
	# check for buffs, statuses, n other stuff
	return fumo.atk

static func deal_damage(fumo:Fumo,damage:int) -> void:
	fumo.hp -= damage
	pass

func _swap_fumo(fumo:Fumo) -> Fumo:
	var team :Array[Fumo]= get_team(fumo.team_id)
	var graveyard:Array[Fumo] = graveyard_map[fumo.team_id]
	graveyard.append(fumo)
	team.erase(fumo)
	return team[0]

	
func round_over() -> RESULTS:
	current_combat_state = COMBAT_STATE.ENDED
	if allies.size() > 1 and opponents.size() == 0:
		print('player won')
		return RESULTS.WIN
	if opponents.size() > 1 and allies.size() == 0:
		print('player lost')
		return RESULTS.LOSS
	else:
		print('draw')
		return RESULTS.DRAW

func _use_ability(ability:Callable) -> void:
	ability.call(allies,opponents)
	

#debug
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_turn") and current_combat_state == COMBAT_STATE.FIGHTING:
		_play_turn()

func _print_status() -> void:
	print("---TURN:" + str(turn_count) + "---")
	print("ABILITY_QUEUE")
	print(ability_queue)
	print("ALLIES:")
	for i in range(allies.size()):
		print(str(i) + ": "+allies[i]._to_string())
	print("OPPONENTS:")
	for i in range(opponents.size()):
		print(str(i) + ": "+opponents[i]._to_string())
