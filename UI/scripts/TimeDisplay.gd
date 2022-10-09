extends CanvasLayer

onready var time = get_parent()
onready var label = $Label

func _process(_delta):
	var current_time = time.time % 1440
	
	var current_hour = str((current_time / 60) % 12)
	if current_hour == "0":
		current_hour = "12"
	if current_hour.length() <= 1:
		current_hour = "0" + current_hour
		
	var current_minute = str(current_time % 60)
	if current_minute.length() <= 1:
		current_minute = "0" + current_minute
	
	var time_string = current_hour + ":" + current_minute
	if current_time >= 720 and current_time != 1440:
		time_string += " PM"
	else:
		time_string += " AM"
		
	label.text = time_string
