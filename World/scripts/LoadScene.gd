extends Node2D

onready var player = $YSort/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = get_node("/root/GlobalVariables").player_position
	
