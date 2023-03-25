extends Node2D

@onready var tile_map = $TileMap
var path_finder
var path = []
var p1 = Vector2i(2, 12)
var p2 = Vector2i(60, 30)

func _ready():
	path_finder = PathFinder.new(tile_map)
	#print(tile_map.get_used_rect().size)
	path_finder.setup_with_occupied_tiles()
	
var init = true
func _process(delta):
	if init:
		path = path_finder.get_path(p1, p2)
		print(path)
		init = false
		$Line2D.clear_points()
		for p in path:
			$Line2D.add_point(tile_map.map_to_local(p))

#	var size = tile_map.get_used_rect().size
#	aStar = AStar2D.new()
#	aStar.reserve_space(size.x * size.y)
#
#	tile_map.get_path()
#
#	print(size)
#
#	for i in size.x:
#		for j in size.y:
#			var idx = getAStarCellId(Vector2(i,j))
#			var p = Vector2i(i,j) #tile_map.local_to_map(Vector2i(i,j))
#
#			if i == 62 || i == 1:
#				print(p, ": ", idx)
#			aStar.add_point(idx, p)
#
#	for i in size.x:
#		for j in size.y:
#			if tile_map.get_cell_source_id(0, Vector2i(i,j)) != -1:
#				#print("adding cell")
#				var idx = getAStarCellId(Vector2(i,j))
#				for vNeighborCell in [Vector2(i,j-1),Vector2(i,j+1),Vector2(i-1,j),Vector2(i+1,j)]:
#					var idxNeighbor = getAStarCellId(vNeighborCell)
#					if aStar.has_point(idxNeighbor):
#						aStar.connect_points(idx, idxNeighbor, false)
#						#print("connected points")
#
#	path = getAStarPath(p1, p2)
#
#func getAStarCellId(vCell:Vector2)->int:
#	return int(vCell.y + vCell.x * tile_map.get_used_rect().size.y)
#
#func getAStarPath(vStartPosition:Vector2, vTargetPosition:Vector2)->Array:
#	var vCellStart = tile_map.local_to_map(vStartPosition)
#	var idxStart = getAStarCellId(vCellStart)
#	print(vCellStart, ": ", idxStart)
#	var vCellTarget = tile_map.local_to_map(vTargetPosition)
#	var idxTarget = getAStarCellId(vCellTarget)
#	print(vCellTarget, ": ", idxTarget)
#	# Just a small check to see if both points are in the grid
#	if aStar.has_point(idxStart) and aStar.has_point(idxTarget):
#		var found_path = aStar.get_point_path(idxStart, idxTarget)
#		print("found: ", found_path)
#		return found_path
#	return []
#
