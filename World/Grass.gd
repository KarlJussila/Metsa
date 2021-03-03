extends Node2D

onready var static_sprite = $Sprite
onready var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.frame = 0

func _process(_delta):
	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_Hurtbox_area_entered(_area):
	static_sprite.hide()
	animated_sprite.show()
	animated_sprite.play("Animate")
