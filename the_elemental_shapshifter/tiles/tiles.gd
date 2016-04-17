extends TileMap

var solidTiles = Array()

func is_tile_solid(type):
	return solidTiles.find(type) != -1

func get_tile_type(pos):
	return get_cell(pos.x / Globals.get("TILE_SIZE"), pos.y / Globals.get("TILE_SIZE"))

func _ready():
	solidTiles.push_back(1)
	solidTiles.push_back(3)
	solidTiles.push_back(5)
	solidTiles.push_back(6)
	solidTiles.push_back(7)
	solidTiles.push_back(8)
	solidTiles.push_back(9)
	solidTiles.push_back(11)
	solidTiles.push_back(12)
	solidTiles.push_back(13)
	solidTiles.push_back(14)
	solidTiles.push_back(15)