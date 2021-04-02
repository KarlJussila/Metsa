extends Node2D

onready var timer = $Timer
onready var global_light = get_node("../Lighting/GlobalLight")
export var minute_length = 0.05
export(Gradient) var daylight_gradient
export var time = 0 setget set_time, get_time

# Start timer
func _ready():
	timer.start(minute_length)
	
func _process(delta):
	global_light.color = daylight_gradient.interpolate((time % 1440) / 1440.0)

func _on_Timer_timeout():
	self.time += 1
	timer.start(minute_length)

func set_time(value):
	time = value

func get_time():
	return time
