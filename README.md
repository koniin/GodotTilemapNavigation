# Pathfinding demos for Godot

Contains:
 * AStar pathfinding
 * NavigationAgent2D based pathfinding

Thanks to Kenney for the assets - https://kenney.nl/assets/1-bit-pack

## Astar on a Tilemap

You can use the PathFinder class as a drop in for your projects.

### Tilemap
Draw a tilemap any way you like, if you use the code below you should keep the walkable tiles empty

#### Use it like so:
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

## NavigationAgent2D with drawn NavigationRegion2D

Check the script for details.
Basic gist is to add NavigationAgent2D to whatever should move and have a NavigationRegion2D defined for where the agent can move.
For the velocity_computed signal to trigger you need to set Avoidance Enabled to true on the NavigationAgent2D.

### Docs

More docs can be found here:
https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html

#### Use it like so:

```

@onready var navigation_agent: NavigationAgent2D = $Mover/NavigationAgent2D
@onready var mover: Sprite2D = $Mover

@export var movement_speed: float = 100.0

var movement_delta: float

func _ready():
	# !!! velocity_computed is only emitted if avoidance enabled = true !!!
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.path_changed.connect(_on_path_changed)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = mover.global_transform.origin
	movement_delta = movement_speed * delta
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_delta
	navigation_agent.set_velocity(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	mover.global_transform.origin = mover.global_transform.origin.move_toward(mover.global_transform.origin + safe_velocity, movement_delta)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			navigation_agent.set_target_position(get_global_mouse_position())


```
