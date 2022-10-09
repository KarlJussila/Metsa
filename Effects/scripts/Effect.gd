extends AnimatedSprite

func _ready():
	var error_code = self.connect("animation_finished", self, "_on_animation_finished")
	if error_code != 0:
		push_error("ERROR: " + error_code)
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
