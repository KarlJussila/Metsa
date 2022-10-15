extends Control

# Establish hearts and max hearts with setters
var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

# Get the heart display components
onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty

# Set the value of hearts, clamped between
# 0 and max_hearts, and adjust the display
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.rect_size.x = hearts * 15

# Set the value of max_hearts, minimum of 1,
# and adjust the display accordingly, including
# making sure the player doesn't have more hearts
# than max hearts
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty != null:
		heart_ui_empty.rect_size.x = max_hearts * 15

func _ready():
	# Get values for hearts and max_hearts
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	
	# Connect signals to change hearts display
	var error_code = PlayerStats.connect("health_changed", self, "set_hearts")
	if error_code != 0:
		push_error("ERROR: " + error_code)
	
	error_code = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	if error_code != 0:
		push_error("ERROR: " + error_code)
