extends Node2D
func _ready():
	Products.file_load()
	for x in Products.optics_name_list:
		print(x)

