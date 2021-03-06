extends Area2D

# Check to see if soft collisions are happening
func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

# Get vector pointing away from soft collisions
func get_push():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	
	# If there are collisions, get a vector pointing away
	# from one of them and return it
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	
	return push_vector
