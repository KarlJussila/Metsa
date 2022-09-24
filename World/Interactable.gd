extends Node2D

signal interacted
var mouse_in_area : bool = false
var player_in_range : bool = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_range and mouse_in_area and Input.is_action_just_pressed("interact"):
		print("Interacted 1")
		emit_signal("interacted")

func _on_InteractArea_mouse_entered():
	mouse_in_area = true
	print("mouse")

func _on_InteractArea_mouse_exited():
	mouse_in_area = false
	
func _on_InteractRange_area_entered(area):
	if (area.get_name() == "PlayerCollisionArea"):
		player_in_range = true
		print("player")
		
func _on_InteractRange_area_exited(area):
	if (area.get_name() == "PlayerCollisionArea"):
		player_in_range = false
