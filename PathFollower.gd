extends PathFollow2D

var speed = 200

func _process(delta):
	set_progress(get_progress() + speed * delta)
