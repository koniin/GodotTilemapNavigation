# Godot Astar on a Tilemap

You can use the PathFinder class as a drop in for your projects.

## Tilemap
Draw a tilemap any way you like, if you use the code below you should keep the walkable tiles empty

### Use it like so:
```

@onready var tile_map = $TileMap

var path_finder

var p1 = Vector2i(2, 12)
var p2 = Vector2i(60, 30)

func _ready():
	path_finder = PathFinder.new(tile_map)
	path_finder.make_empty_tiles_pathable()
	update_path()
	
func update_path():
	var path = path_finder.get_path(p1, p2)
	$Line2D.clear_points()
	for p in path:
		$Line2D.add_point(tile_map.map_to_local(p))

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			p1 = tile_map.local_to_map(get_global_mouse_position())
		if event.button_index == MOUSE_BUTTON_RIGHT:
			p2 = tile_map.local_to_map(get_global_mouse_position())
			
		update_path()


```