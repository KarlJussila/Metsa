extends Node2D

onready var timer = $Timer
export var minute_length = 0.05
export var time = 0 setget set_time, get_time

signal minute_passed(time)

# Start timer
func _ready():
	timer.start(minute_length)
	
func _process(_delta):
	pass

func _on_Timer_timeout():
	self.time += 1
	timer.start(minute_length)
	emit_signal("minute_passed", time)

func set_time(value):
	time = value

func get_time():
	return time
