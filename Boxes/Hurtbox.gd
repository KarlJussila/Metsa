extends Area2D

# Establish signals
signal hurt
signal invincibility_started
signal invincibility_ended

# Invincibility boolean with setter and getter
var invincible = false setget set_invincible, get_invincible

# Grabbing components
onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

# Setter for invincibility, also emits the proper signals
func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

# Getter for invincibility boolean
func get_invincible():
	return invincible

# Function to start invincibility for given duration
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

# When the hurtbox sends an area entered signal,
# send a hurt signal if the entity is not invincible
func _on_Hurtbox_area_entered(area):
	if not invincible:
		emit_signal("hurt", area)

# When the invincibility timer runs out, disable invincibility
func _on_Timer_timeout():
	self.invincible = false

# Disable hurtbox during invincibility to allow
# the hitbox to re-enter the hurtbox when invincibility
# runs out. Otherwise, the hitbox might never leave
# the hurtbox, never sending another area_entered signal
func _on_Hurtbox_invincibility_started():
	collision_shape.set_deferred("disabled", true)

# Re-enable the hurtbox after invincibility ends
func _on_Hurtbox_invincibility_ended():
	collision_shape.set_deferred("disabled", false)
