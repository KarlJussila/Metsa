extends Node2D

var item_name
var item_quantity

func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name = "iron_sword"
	elif rand_val == 1:
		item_name = "bow"
	else:
		item_name = "arrow"
	
	$TextureRect.texture = load("res://UI/item_icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["stack_size"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = str(item_quantity)
		
func add_item_quantity(amount):
	item_quantity += amount
	$Label.text = str(item_quantity)

func remove_item_quantity(amount):
	item_quantity -= amount
	$Label.text = str(item_quantity)
