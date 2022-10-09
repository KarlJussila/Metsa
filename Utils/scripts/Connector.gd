extends Node2D

# create variables which are connector-specific
export var end_location = "res://World/scenes/World.tscn"
export var player_position = Vector2.ZERO
	
# transports player to new scene and location
func transport_player():
	get_node("/root/GlobalVariables").player_position = player_position
	var error_code = get_tree().change_scene(end_location)
	if error_code != 0:
		push_error("ERROR: " + error_code)
		
func _on_TransportRegion_area_entered(area):
	if (area.get_name() == "PlayerCollisionArea"):
		transport_player()
	
