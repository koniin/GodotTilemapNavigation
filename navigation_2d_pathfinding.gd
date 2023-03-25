extends Node2D

@onready var navigation_agent: NavigationAgent2D = $Mover/NavigationAgent2D
@onready var mover: Sprite2D = $Mover
@export var movement_speed: float = 100.0

var movement_delta: float

# Called when the node enters the scene tree for the first time.
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
#
#	var next_location = navigation_agent.get_next_path_position()
##	print("next_location: ", next_location)
#	var v = (next_location - mover.global_position).normalized()
#	navigation_agent.set_velocity(v)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
#	mover.position += safe_velocity

	mover.global_transform.origin = mover.global_transform.origin.move_toward(mover.global_transform.origin + safe_velocity, movement_delta)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			navigation_agent.set_target_position(get_global_mouse_position())
		
func _on_path_changed():
	print("new path: ", navigation_agent.get_current_navigation_path())
