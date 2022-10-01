extends Node2D

# create variables which are connector-specific
export var end_location = "res://World.tscn"
export var player_position = Vector2.ZERO

#import player Node
onready var PLAYER = preload("res://Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# transports player to new scene and location
func transport_player():
	# change to connected scene, then instance the player again
	get_tree().change_scene(end_location)
	var player = PLAYER.instance()
	get_node("YSort").add_child(player)
	# place player in correct position on new scene
	player.position = player_position
		
func _on_TransportRegion_area_entered(area):
	if (area.get_name() == "PlayerCollisionArea"):
		print("player")
		transport_player()
	
