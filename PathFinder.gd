extends RefCounted

class_name PathFinder

# THIS CLASS IS ALL BASED ON:
# https://www.gdquest.com/tutorial/godot/2d/tactical-rpg-movement/lessons/04.pathfinding-and-path-drawing/

var _astar
var tile_map

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

func _init(tilemap: TileMap):
	_astar = AStar2D.new()
	tile_map = tilemap

# Sets the size of the Astar area to be that of the assigned map area
# - set some kind of tile in the BOTTOM RIGHT corner to get the biggest size
# - OR send in the size of the tilemap
# then it adds all the tiles that are set as obstacles for the Astar algorithm
# - that is all tiles that are not -1
func make_empty_tiles_pathable(tilemap_size: Vector2i = Vector2i.ZERO):
	var blocked_tiles = get_tilemap_occupied_tiles(tile_map)
	var size = tilemap_size
	if size == Vector2i.ZERO:
		size = tile_map.get_used_rect().size
	add_all_by_size(size, blocked_tiles)

func add_and_connect(walkable_points):
	var walkable_cells = {}
	for p in walkable_points:
		walkable_cells[cell_index(Vector2i(p.x, p.y))] = Vector2i(p.x, p.y)
		
	_add_and_connect_points(walkable_cells)

func add_all_by_size(size: Vector2i, blocked_tiles):
	var walkable_points = []
	for x in size.x:
		for y in size.y:
			var pos = Vector2i(x, y)
			if !blocked_tiles.has(pos):
				walkable_points.push_back(pos)
	add_and_connect(walkable_points)

# send in -1 as cell_source_id to fetch all tiles that are EMPTY
func get_tilemap_occupied_tiles(tilemap, cell_source_id = 0):
	var size = tilemap.get_used_rect().size
	var blocked_tiles = {}
	for x in size.x:
		for y in size.y:
			var cell_id = tilemap.get_cell_source_id(0, Vector2i(x, y))
			if cell_id == cell_source_id:
				blocked_tiles[Vector2i(x, y)] = 1
	return blocked_tiles

func cell_index(vCell:Vector2i)->int:
	return int(vCell.y + vCell.x * tile_map.get_used_rect().size.y)
	
func get_path(start: Vector2i, end: Vector2i):
	var start_index: int = cell_index(start)
	var end_index: int = cell_index(end)
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index, end_index)
	else:
		return []
		
func _add_and_connect_points(cell_mappings: Dictionary) -> void:
	for index in cell_mappings:
		_astar.add_point(index, cell_mappings[index])

	for index in cell_mappings:
		for neighbor_index in _find_neighbor_indices(cell_mappings[index], cell_mappings):
			# The AStar2D.connect_points() function connects two points on the graph by index, *not*
			# by coordinates.
			_astar.connect_points(neighbor_index, index)
			
func _find_neighbor_indices(cell: Vector2i, cell_mappings: Dictionary) -> Array:
	var out := []
	for direction in DIRECTIONS:
		var neighbor_pos: Vector2i = cell + direction
		var n_index = cell_index(neighbor_pos)
		if not cell_mappings.has(n_index):
			continue
		if not _astar.are_points_connected(cell_index(cell), n_index):
			out.push_back(n_index)
	return out
