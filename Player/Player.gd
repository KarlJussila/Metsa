extends KinematicBody2D

const MAX_SPEED = 80
const ROLL_SPEED = 125
const ACCELERATION = 15
const FRICTION = 15

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

# Fetch animations when ready
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func _physics_process(delta):
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
		
		# Update roll direction
		roll_vector = input_vector
		
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
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state(_delta):
	animation_state.travel("Roll")
	velocity = roll_vector * ROLL_SPEED
	move()

func attack_state(_delta):
	animation_state.travel("Attack")
	velocity = move_and_slide(velocity * 0.95)

# Scale velocity relative to frame rate, and move the player,
# checking for collisions and updating the velocity accordingly	
func move():
	velocity = move_and_slide(velocity)

func attack_animation_end():
	state = MOVE

func roll_animation_end():
	velocity *= 0.5
	state = MOVE
