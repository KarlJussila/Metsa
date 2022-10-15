extends CanvasModulate

onready var global_time = get_node("/root/GlobalTime")
export(Gradient) var daylight_gradient


func _ready():
	global_time.connect("minute_passed", self, "_interpolate_lighting")
	_interpolate_lighting(global_time.get_time())
	
func _interpolate_lighting(time):
	self.color = daylight_gradient.interpolate((time % 1440) / 1440.0)
