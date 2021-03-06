extends KinematicBody2D

# Preload the bat's death animation
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

# Some variables to calculate knockback and movement
var knockback = Vector2.ZERO
const KNOCKBACK = 180
var velocity = Vector2.ZERO

export var FRICTION = 5
export var ACCELERATION = 15
export var MAX_SPEED = 50


# Load in the bat's components
onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController

# Default to idle state
enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _physics_process(delta):
	# Calculate knockback, if any
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)
	
	# Select state
	match state:
		IDLE:
			# Decelerate the bat
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
			
			# Check for player in range
			seek_player()
			
			# Update wandering every once in a while
			if wander_controller.get_time_left() == 0:
				update_wander()
		
		WANDER:
			# Check for player in range
			seek_player()
			
			# Update wandering every once in a while
			if wander_controller.get_time_left() == 0:
				update_wander()
			
				# Accelerate toward wandering target
				accelerate_toward(wander_controller.target_position)
			
			# Update wandering if target is reached
			if global_position.distance_to(wander_controller.target_position) <= 5:
				update_wander()
			
		CHASE:
			# If there is a detected player, accelerate
			# toward that player
			var player = player_detection_zone.player
			if player != null:
				accelerate_toward(player.global_position)
			
			# Otherwise, switch back to idle state
			else:
				state = IDLE

	# Flip the sprite to face the direction the bat is moving
	sprite.flip_h = velocity.x < 0
	
	# If there are nearby bats, adjust velocity to avoid collisions
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push() * 5
		
	# Apply velocity
	velocity = move_and_slide(velocity)

# Function to accelerate toward a position
func accelerate_toward(position):
	var direction_vector = global_position.direction_to(position)
	velocity = velocity.move_toward(direction_vector * MAX_SPEED, ACCELERATION)

# Change state to chase if there is a player in range
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

# Restart the wander clock and choose between
# idle and wander at random
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))

# Pick a random state from the provided list
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

# When the bat is reduced to zero health
func _on_Stats_no_health():
	# Kill the bat
	queue_free()
	
	# Play an instance of the death animation
	var bat_death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(bat_death_effect)
	bat_death_effect.global_position.x = global_position.x
	bat_death_effect.global_position.y = global_position.y - 12

# When a hurt signal is received
func _on_Hurtbox_hurt(area):
	# Play the hurt animation
	animation_player.play("Hurt")
	
	# Damage the bat and knock it back
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK
