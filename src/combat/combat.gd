extends Node2D
class_name Combat

var allies:Array[Fumo] = []
var feinted_allies:Array[Fumo] = []
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

enum COMBAT_STATE {
	STARTING,
	FIGHTING,
	ENDED,
	}



enum RESULTS {
	WIN,
	LOSS,
	DRAW
	}

var current_combat_state:COMBAT_STATE = COMBAT_STATE.STARTING

var priority_sort:Callable = func(ally:Fumo,opp:Fumo) -> bool:

	return ally.atk > opp.atk
func _ready() -> void:
	allies = _generate_team()
	opponents = _generate_team()
	_start_round()
	pass



func _generate_team() -> Array[Fumo]:
	var team :Array[Fumo] = []
	for i in range(6):	
		var random_fumo:String = FumoFactory.FUMOS.pick_random()
		team.append(FumoFactory.make_fumo(random_fumo))	
	return team

func _start_round() -> void:
	current_combat_state = COMBAT_STATE.FIGHTING
	var ally_start_abilities :Array = _play_abilities("on_round_start",allies)

func _play_abilities(ability_query:StringName,team:Array[Fumo]) -> Array[Fumo]:
	var ability_fumos :Array = []
	for fumo:Fumo in team:
		if fumo.has_method(ability_query):
			ability_fumos.append([ability_query,fumo])
	ability_fumos.sort_custom(priority_sort)
	return ability_fumos

	# while !ability_fumos.is_empty():
	# 	ability_fumos.pop_front().call(ability_query, allies, opponents)
	



func _play_turn() -> void:
	_print_status()
	#smthn turn based
	var front_ally:Fumo = allies[0]
	var front_opp:Fumo = opponents[0]
	#animate them smashing into each other.
	_fight(front_ally,front_opp)

	if front_ally.hp == 0:
		feinted_allies.append(allies.pop_front())
		print(front_ally.name_str + " was KO'ed")
		if allies.size() < 0:
			front_ally =_swap_fumo(allies)

	if front_opp.hp == 0:
		feinted_opponents.append(opponents.pop_front())
		print(front_opp.name_str + " was KO'ed")
		if opponents.size() < 0:
			front_opp = _swap_fumo(opponents)
	if (allies.size() == 0 or opponents.size() == 0):
		round_over()
	turn_count += 1
	print("Turn Over")

func _fight(ally:Fumo,opponent:Fumo) -> void:
	#smash each other
	ally.hp -= _calculate_damage(opponent)
	opponent.hp -= _calculate_damage(ally)

func _calculate_damage(fumo:Fumo) -> int:
	# check for buffs, statuses, n other stuff
	return fumo.atk

func _swap_fumo(fumo_team:Array[Fumo]) -> Fumo:
	# we also need to check for draw cases
	# bad func
	if fumo_team == allies:
		return fumo_team[0]

	elif fumo_team == opponents:
		feinted_opponents.append(opponents.pop_front())
		return fumo_team[0]
	return null
	
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
	print("ALLIES:")
	for i in range(allies.size()):
		print(str(i) + ": "+allies[i]._to_string())
	print("OPPONENTS:")
	for i in range(opponents.size()):
		print(str(i) + ": "+allies[i]._to_string())
