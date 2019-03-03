extends Sprite

const MOVEMENT_SPEED = 96
const POINT_RADIUS = 5

var movement_points = 0

var turn_path = []


# once per frame
func _process(delta):
	
	if turn_path:
		
		var target = turn_path[0]
		var direction = (target - position).normalized()
		position += direction * MOVEMENT_SPEED * delta
		if position.distance_to(target) < POINT_RADIUS:
			turn_path.remove(0)
			if turn_path.size() == 0:
				turn_path = null


# MAKE NEW PATH LIMITED BY MOVEMENT_POINTS
func make_turn_path(path):
	
	turn_path = []
	if path == null:
		turn_path = null
	
	for i in movement_points:

		turn_path.append(path[0])
		path.remove(0)
		
		movement_points -= 1
		
		if path.size() == 0:
			path = null
			break
	
	print(turn_path)