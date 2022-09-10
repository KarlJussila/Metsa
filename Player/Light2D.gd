extends Light2D

var intensity = self.energy

func _process(delta):
	if Input.is_action_just_pressed("light"):
		self.intensity = 1.0 - self.intensity
		self.energy = self.intensity
