extends Node2D

const SlotClass = preload("res://UI/Slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
		
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if (event is InputEventMouseButton
	&& event.button_index == BUTTON_LEFT
	&& event.pressed):
		# Currently holding an item
		if holding_item != null:
			
			# Clicked slot is empty
			if slot.item == null:
				slot.put_into_slot(holding_item)
				holding_item = null
			
			# Clicked slot has an item
			else:
				
				# Items are different
				if holding_item.item_name != slot.item.item_name:
					
					# Swap the items
					var temp_item = slot.item
					slot.pick_from_slot()
					temp_item.global_position = event.global_position
					slot.put_into_slot(holding_item)
					holding_item = temp_item
				
				# Items are the same
				else:
					
					# Try to merge the items
					var stack_size = int(JsonData.item_data[holding_item.item_name]["stack_size"])
					var space_in_stack = stack_size - slot.item.item_quantity
					
					# If there is space to merge the stacks fully
					if space_in_stack >= holding_item.item_quantity:
						
						# Merge them and free the held item
						slot.item.add_item_quantity(holding_item.item_quantity)
						holding_item.queue_free()
						holding_item = null
					
					# If there is not enough space to merge fully
					else:
						
						# Transfer as much as possible
						slot.item.add_item_quantity(space_in_stack)
						holding_item.remove_item_quantity(space_in_stack)
		
		# If not holding an item and there is an item in the slot
		elif slot.item != null:
			
			# Pick up the item
			holding_item = slot.item
			slot.pick_from_slot()
			holding_item.global_position = get_global_mouse_position()

func _input(event):
	if holding_item != null:
		holding_item.global_position = get_global_mouse_position()
