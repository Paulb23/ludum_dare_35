extends TileMap

var solidTiles = Array()

func is_tile_solid(type):
	return solidTiles.find(type) != -1

func get_tile_type(pos):
	return get_cell(pos.x / Globals.get("TILE_SIZE"), pos.y / Globals.get("TILE_SIZE"))

func _ready():
	solidTiles.push_back(1)


