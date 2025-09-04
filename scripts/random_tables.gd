extends Node

var wilderness_discovery_table = {
	1: "unnatural_feature",
	2: "natural_feature",
	3: "natural_feature",
	4: "evidence",
	5: "creature",
	6: "structure"
}

func roll_on_wilderness_discovery_table(d6: int) -> String:
	return wilderness_discovery_table.get(d6, "unnatural_feature")

var terrain_type_table = {
	"plains": {
		2: "swamp",
		3: "swamp",
		4: "swamp",
		5: "hills",
		6: "hills",
		7: "plains",
		8: "plains",
		9: "forest",
		10: "forest",
		11: "desert",
		12: "desert"
	},
	"hills": {
		2: "plains",
		3: "plains",
		4: "plains",
		5: "forest",
		6: "forest",
		7: "hills",
		8: "hills",
		9: "mountain",
		10: "mountain",
		11: "desert",
		12: "desert"
	},
	"forest": {
		2: "hills",
		3: "hills",
		4: "hills",
		5: "swamp",
		6: "swamp",
		7: "forest",
		8: "forest",
		9: "plains",
		10: "plains",
		11: "mountain",
		12: "mountain"
	},
	"swamp": {
		2: "hills",
		3: "hills",
		4: "hills",
		5: "plains",
		6: "plains",
		7: "swamp",
		8: "swamp",
		9: "forest",
		10: "forest",
		11: "mountain",
		12: "mountain"
	},
	"desert": {
		2: "forest",
		3: "forest",
		4: "forest",
		5: "hills",
		6: "hills",
		7: "desert",
		8: "desert",
		9: "plains",
		10: "plains",
		11: "mountain",
		12: "mountain"
	},
	"mountain": {
		2: "plains",
		3: "plains",
		4: "plains",
		5: "hills",
		6: "hills",
		7: "mountain",
		8: "mountain",
		9: "forest",
		10: "forest",
		11: "desert",
		12: "desert"
	},
}

func roll_on_terrain_type_table(current_terrain_type: String,IId6: int) -> String:
	if not terrain_type_table.has(current_terrain_type):
		push_error("Invalid terrain type: " + str(current_terrain_type))
		return current_terrain_type  # fallback to input

	return terrain_type_table[current_terrain_type].get(IId6, current_terrain_type)
