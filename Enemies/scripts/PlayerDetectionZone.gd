extends Area2D

# Var to hold the player
var player = null

# Boolean function to check if there is a player in range
func can_see_player():
	return player != null

# When the player enters the detection zone,
# store them in the player variable
func _on_PlayerDetectionZone_body_entered(body):
	player = body

# When the player leaves, reset to null
func _on_PlayerDetectionZone_body_exited(_body):
	player = null
