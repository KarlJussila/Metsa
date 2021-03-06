extends Node

# Health variables with setters
export var max_health = 1 setget set_max_health
var health = max_health setget set_health

# Establish signals
signal no_health
signal health_changed(value)
signal max_health_changed(value)

# Max health setter
func set_max_health(value):
	# Change max health, min of 1, and emit signal
	max_health = max(1, value)
	emit_signal("max_health_changed", max_health)

# Health setter
func set_health(value):
	# Change health and emit signal. Send no_health signal
	# if the health is <= 0
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	# Set health to max_health when ready
	self.health = max_health
