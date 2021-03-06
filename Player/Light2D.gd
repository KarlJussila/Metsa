extends Light2D

func _process(delta):
	if Input.is_action_just_pressed("light"):
		self.energy = 1.0 - self.energy
