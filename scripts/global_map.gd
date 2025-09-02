extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var tile_collection: Array = [
	{
		"terrain_type": "forest",
		"tile_set_source": 0,
		"atlas_coords_x": 0,
		"atlas_coords_y": 0
	},
	{
		"terrain_type": "unknown",
		"tile_set_source": 0,
		"atlas_coords_x": 1,
		"atlas_coords_y": 0
	},
	{
		"terrain_type": "desert",
		"tile_set_source": 0,
		"atlas_coords_x": 2,
		"atlas_coords_y": 0
	},
	{
		"terrain_type": "hills",
		"tile_set_source": 0,
		"atlas_coords_x": 3,
		"atlas_coords_y": 0
	},
	{
		"terrain_type": "plains",
		"tile_set_source": 0,
		"atlas_coords_x": 4,
		"atlas_coords_y": 0
	},
	{
		"terrain_type": "swamp",
		"tile_set_source": 0,
		"atlas_coords_x": 5,
		"atlas_coords_y": 0
	},
	{
		"terrain_type": "mountain",
		"tile_set_source": 0,
		"atlas_coords_x": 6,
		"atlas_coords_y": 0
	},
]

func tilejson_to_tilecell(tilejson: Dictionary) -> Dictionary:
	return {
		"tile_set_source": tilejson.tile_set_source,
		"atlas_coords": Vector2i(tilejson.atlas_coords_x,tilejson.atlas_coords_y)
	}

func get_random_tile(tile_collection: Array) -> Dictionary:
	if tile_collection.size() == 0:
		push_error("Tile collection is empty!")
		return {}
	var index = randi() % tile_collection.size()
	return tile_collection[index]
	
func generate_hex(
	local_coords: Vector2i,
	tile_set_source: int,
	atlas_coords: Vector2i
	) -> void:
		#Check if hex is not generated already
		if tile_map_layer.get_cell_source_id(local_coords) == -1:
			tile_map_layer.set_cell(
				local_coords, 
				tile_set_source, 
				atlas_coords
			)

func _ready() -> void:
	generate_hex(
		Vector2i(0,0), 
		tilejson_to_tilecell(tile_collection[0]).tile_set_source, 
		tilejson_to_tilecell(tile_collection[0]).atlas_coords
	)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("generate_hex"):
		assert(event is InputEventMouseButton)
		var mouse_position: Vector2 = event.global_position
		var local_coords: Vector2i = tile_map_layer.local_to_map(tile_map_layer.to_local(mouse_position))
		generate_hex(
			local_coords, 
			tilejson_to_tilecell(get_random_tile(tile_collection)).tile_set_source, 
			tilejson_to_tilecell(get_random_tile(tile_collection)).atlas_coords
		)
