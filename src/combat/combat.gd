extends Node2D
class_name Combat

var allies:Array[Fumo]
var feinted_allies:Array[Fumo] = []
var opponents:Array[Fumo]
var feinted_opponents:Array[Fumo] = []

# signal turn_started
# signal turn_ended
# signal ally_feinted
# signal opponent_feinted
# signal spell_casted
# signal damage_taken
# signal fumo_summoned


func _ready() -> void:
	pass


func _generate_team(fumo_team):	
	for i in range(6):	
		var random_fumo: = FumoFactory.FUMOS.pick_random()
		fumo_team.append(FumoFactory.make_fumo(random_fumo))	
	pass

func _play_turn() -> void:

	while allies.size() != 0 or opponents.size() !=  0:
		var front_ally:Fumo = allies[0]
		var front_opp:Fumo = allies[0]
		#animate them smashing into each other.
		_fight(front_ally,front_opp)
		if front_ally.hp == 0:
			front_ally =_swap_fumo(allies)
		if front_opp.hp == 0:
			front_opp = _swap_fumo(allies)


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
		feinted_allies.append(allies.pop_front())
		if allies.size() == 0:
			#lose
			pass
		else:
			return fumo_team[0]

	elif fumo_team == opponents:
		feinted_opponents.append(opponents.pop_front())
		if opponents.size() == 0:
			#win
			pass
		else:
			return fumo_team[0]
	return null
	
	
	
