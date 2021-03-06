extends Node2D

onready var static_sprite = $Sprite
onready var animated_sprite = $AnimatedSprite

func _ready():
	# Make sure to reset break animation to 0th frame
	animated_sprite.frame = 0

# When break animation ends, remove the grass
func _on_AnimatedSprite_animation_finished():
	queue_free()

# When the hurtbox is hit, hide the grass sprite
# and display the break animation
func _on_Hurtbox_hurt(_area):
	static_sprite.hide()
	animated_sprite.show()
	animated_sprite.play("Animate")
