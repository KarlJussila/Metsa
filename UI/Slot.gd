extends Panel

var ItemClass = preload("res://UI/Item.tscn")
var item = null
onready var inventory_node = find_parent("Inventory")

func _ready():
	if randi() % 2:
		item = ItemClass.instance()
		add_child(item)

func pick_from_slot():
	remove_child(item)
	inventory_node.add_child(item)
	item = null
	
func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	inventory_node.remove_child(item)
	add_child(item)
