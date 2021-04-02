extends Node

var item_data: Dictionary

func _ready():
	item_data = load_data("res://Data/ItemData.json")
	
func load_data(file_path):
	var file_data = File.new()
	file_data.open(file_path, File.READ)
	
	var json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
