extends KinematicBody2D

# Movement stats
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var ACCELERATION = 15
export var FRICTION = 15

# Length of invincibility after being hit in seconds
export var invincibility_length = 1.5

# Default to move state
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

# Movement vectors
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

# Fetch player stats (health)
var stats = PlayerStats

# Fetch animations when ready
onready var sprite = $Sprite
onready var hurt_animation = $Sprite/HurtAnimation
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

func _ready():
	# Connect the no_health signal to removing the player
	stats.connect("no_health", self, "queue_free")
	
	# Reset any modulate functions that may be left over
	sprite.modulate = Color(1, 1, 1, 1)
	
	# Start the animation tree
	animation_tree.active = true

func _physics_process(delta):
	# State machine
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state():
	
	# Get direction vector for the player
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Normalize the direction vector
	input_vector = input_vector.normalized()
	
	# When moving
	if input_vector != Vector2.ZERO:
		
		# Update roll direction and knockback vector
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		
		# Update animation
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		
		# Accelerate the player in the input direction, capped at MAX_SPEED
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
		velocity = velocity.clamped(MAX_SPEED)
	
	# When idle
	else:
		
		# Change to idle animnation
		animation_state.travel("Idle")
		
		# Similarly, decelerate the player
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	# Move the player
	move()
	
	# Change to attack state when the player attacks
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	# Change to roll state and engage invincibility
	# for the duration when the player rolls
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		hurtbox.start_invincibility(0.5)

func roll_state(_delta):
	# Change to roll animation
	animation_state.travel("Roll")
	
	# Move along the roll vector at constant speed
	velocity = roll_vector * ROLL_SPEED
	move()

func attack_state(_delta):
	# Start attack animation
	animation_state.travel("Attack")
	
	# Reduce velocity gradually, to allow the player
	# to continue moving forward
	velocity = move_and_slide(velocity * 0.95)

# Scale velocity relative to frame rate, and move the player,
# checking for collisions and updating the velocity accordingly	
func move():
	velocity = move_and_slide(velocity)

# Switch back to move state at the end of attack animation
func attack_animation_end():
	state = MOVE

# Reduce velocity and transition back to move state
# at the end of the roll animation
func roll_animation_end():
	velocity *= 0.5
	state = MOVE

# Hurt signal
func _on_Hurtbox_hurt(area):
	# Damage the player 
	stats.health -= area.damage
	
	# Play hurt animation for the duration of invincibility
	hurt_animation.play("Hurt", -1, 1.0 / (invincibility_length * 2))
	hurtbox.start_invincibility(0.5 * (invincibility_length * 2))
