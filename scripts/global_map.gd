extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

const TILE_UNKNOWN: Dictionary = {
	"terrain_type": "unknown",
	"tile_set_source": 0,
	"atlas_coords_x": 1,
	"atlas_coords_y": 0
}

var TILE_COLLECTION: Array = [
	{
		"terrain_type": "forest",
		"tile_set_source": 0,
		"atlas_coords_x": 0,
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

func get_random_tile(TILE_COLLECTION: Array) -> Dictionary:
	if TILE_COLLECTION.size() == 0:
		push_error("Tile collection is empty!")
		return {}
	var index = randi() % TILE_COLLECTION.size()
	return TILE_COLLECTION[index]
	
func generate_hex(
	local_coords: Vector2i
	) -> void:
		var random_tile: Dictionary = get_random_tile(TILE_COLLECTION)
		var tile_set_source: int = tilejson_to_tilecell(random_tile).tile_set_source
		var atlas_coords: Vector2i =  tilejson_to_tilecell(random_tile).atlas_coords		

		tile_map_layer.set_cell(
			local_coords, 
			tile_set_source, 
			atlas_coords
		)
		var cell_tile_data: TileData = tile_map_layer.get_cell_tile_data(local_coords)
		cell_tile_data.set_custom_data("terrain_type", random_tile.get("terrain_type", "unknown"))
		
		#make ungenerated surrounding cells unknown
		var unknown_tilecell: Dictionary = tilejson_to_tilecell(TILE_UNKNOWN)
		var surrounding_cells_coords: Array[Vector2i] = tile_map_layer.get_surrounding_cells(local_coords)
		for surrounding_cell_coords in surrounding_cells_coords:
			if tile_map_layer.get_cell_source_id(surrounding_cell_coords) == -1:
				tile_map_layer.set_cell(
				surrounding_cell_coords, 
				unknown_tilecell.tile_set_source, 
				unknown_tilecell.atlas_coords
			)
			var unknown_cell_tile_data: TileData = tile_map_layer.get_cell_tile_data(surrounding_cell_coords)
			unknown_cell_tile_data.set_custom_data("terrain_type", TILE_UNKNOWN.get("terrain_type", "unknown"))

func _ready() -> void:
	generate_hex(Vector2i(0,0))
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("generate_hex"):
		assert(event is InputEventMouseButton)
		var mouse_position: Vector2 = event.global_position
		var local_coords: Vector2i = tile_map_layer.local_to_map(tile_map_layer.to_local(mouse_position))
		
		#check if cliked hex is unknown
		var clicked_cell_tile_data: TileData = tile_map_layer.get_cell_tile_data(local_coords)
		if clicked_cell_tile_data.get_custom_data("terrain_type") == TILE_UNKNOWN.get("terrain_type", "unknown"):
			generate_hex(local_coords)
