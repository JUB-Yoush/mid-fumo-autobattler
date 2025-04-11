extends RefCounted
class_name TeamGenerator

static func generate_team(team_id:CombatData.TEAM) -> Array[Fumo]:
	# how to make teams?
	# start from nothing and give them 10 gold
	# loop for turn iterations (so it's the same as the player)
	# every turn the cpu can:
	# buy a fumo mid
	# sell a fumo low
	# level up a fumo low
	# re-arrange their team mid
	# buy an item mid
	var simulated_team: Array[Fumo] = []

	for i in range(GlobalRefs.turns):
		var sim_gold:int = 10
		while sim_gold >= 2:	
			var rng :int= randi_range(0,7)

			if simulated_team.size() < 3 and sim_gold >= 3:
				if add_fumo(simulated_team):
					sim_gold -= 3
				
			if rng >=0 and rng < 2 and sim_gold >= 3 and simulated_team.size() < GlobalRefs.TEAM_LIMIT:
				if add_fumo(simulated_team):
					sim_gold -= 3
			elif rng >=2 and rng < 4 and sim_gold >= 3:
				if buy_item(simulated_team):
					sim_gold -= 3
			elif rng >=4 and rng < 5:
				rearrange_team(simulated_team)
			elif rng == 6:
				if sell_fumo(simulated_team):
					sim_gold += 3
			elif rng == 7 and sim_gold >= 3:
				lvlup_fumo(simulated_team)
				sim_gold -= 3
	print_debug(simulated_team)
	return simulated_team

static func add_fumo(team:Array[Fumo]) -> bool:
	var fumo:Fumo = FumoFactory.make_random_fumos(3,GlobalRefs.tier).pick_random()
	team.append(fumo)
	return true

static func sell_fumo(team:Array[Fumo]) -> bool:
	if team.size() <= 1:
		return false
	team.erase(team.pick_random())
	return true

static func buy_item(team:Array[Fumo]) -> bool:
	if team.size() <= 1:
		return false
	var item:Item = ItemFactory.make_random_items(3,GlobalRefs.tier).pick_random()
	item.on_sale(team.pick_random())
	return true

static func rearrange_team(team:Array[Fumo]) -> bool:
	if team.size() <= 1:
		return false
	
	var fumo1 :Fumo= team.pick_random()
	var fumo2 :Fumo= team.pick_random()

	var f1_index:int = team.find(fumo1)
	var f2_index:int = team.find(fumo2)

	var temp2:Fumo = team[f2_index]

	team[f1_index] = team[f2_index]
	team[f2_index] = temp2
	return true

static func lvlup_fumo(team:Array[Fumo]) -> bool:
	if team.size() <= 1:
		return false
	team.pick_random().exp_points += 1
	return true
