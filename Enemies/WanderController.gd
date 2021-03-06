extends Node2D

# Size of box the entity can wander in
export var wander_range = 32

# Get position to wander around
onready var start_position = global_position

# Initialize target of wandering
onready var target_position = global_position

# Get timer component
onready var timer = $Timer

# Select random target position in wander range
func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector
	
# Return time left on timer
func get_time_left():
	return timer.time_left

# Start the timer for provided duration
func start_wander_timer(duration):
	timer.start(duration)

# Update target position when timer runs out
func _on_Timer_timeout():
	update_target_position()
