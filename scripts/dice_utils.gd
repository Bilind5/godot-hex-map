extends Node

enum RollModifier {
	FLAT,
	ADVANTAGE,
	DISADVANTAGE,
	REROLL_ONES,
	EXPLODE
}

func roll_NdM(M: int, N: int = 1, sum_option: bool = true, modifiers: Array = []) -> Array:
	var results: Array = []
	
	for i in range(N):
		var roll = randi() % M + 1  # base roll
		
		for mod in modifiers:
			match mod["type"]:
				RollModifier.FLAT:
					roll += mod.get("value", 0)
				
				RollModifier.ADVANTAGE:
					var extra = randi() % M + 1
					roll = max(roll, extra)
				
				RollModifier.DISADVANTAGE:
					var extra = randi() % M + 1
					roll = min(roll, extra)
				
				RollModifier.REROLL_ONES:
					if roll == 1:
						roll = randi() % M + 1
				
				RollModifier.EXPLODE:
					var explode_roll = roll
					while explode_roll == M:
						var extra = randi() % M + 1
						roll += extra
						explode_roll = extra  # check if extra die also explodes
		
		results.append(roll)
	
	if N > 1 and sum_option:
		var sum = 0
		for result in results:
			sum += result
		results = [sum]
	
	return results
