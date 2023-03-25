extends Control

func _ready():
	$AStar.pressed.connect(func(): get_tree().change_scene_to_file("res://astar_pathfinding.tscn"))
	$Navigation2D.pressed.connect(func(): get_tree().change_scene_to_file("res://navigation_2d_pathfinding.tscn"))

