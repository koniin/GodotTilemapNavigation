extends Node2D

var count = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.timeout.connect(func(): 
		if count > 2: 
			return 
			
		var p = load("res://path_follower.tscn")
		var path_follower = p.instantiate()
		$Path2D.add_child(path_follower)
		count += 1
	)
	
	random_path()

func random_path():
	$Path2D.curve.clear_points()
	
	var v_size = get_viewport_rect().size
	var y_max = int(v_size.y) - 64
	var previous_point = Vector2(0, randi_range(64, y_max))
	$Path2D.curve.add_point(previous_point)
	
	var x = randi_range(64, 128)
	previous_point = Vector2(x, previous_point.y)
	$Path2D.curve.add_point(previous_point)
	
	var n = 4 #randi() % 3 + 3 # 3 - 6 random points in path
	
	var points = random_dist_sum(n, 800)
	
	for i in n:
		var prev_x = x
		x += points[i]
		if abs(x - prev_x) < 64:
			x += 64
		$Path2D.curve.add_point(Vector2(x, previous_point.y))
		
		var next_y = 0
		if i == n - 1: # Always end at the middle point
			next_y = int(v_size.y) / 2
		else:	
			next_y = randi_range(64, y_max)
			while abs(next_y - previous_point.y) < 64:
				next_y = randi_range(64, y_max)
			
		previous_point = Vector2(x, next_y)
		$Path2D.curve.add_point(previous_point)
		
		print(i)
	
	$Path2D.curve.add_point(Vector2(int(v_size.x), previous_point.y))
	
# generate count points that equals the sum when added together
func random_dist_sum(count, sum):
	var nums = []
	var s = 0
	for i in count:
		nums.append(randf())
		s += nums[i]
	
	for i in count:
		nums[i] = (nums[i] / s) * sum
	return nums
	
