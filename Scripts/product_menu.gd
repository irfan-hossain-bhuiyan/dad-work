extends Control
var button_label:PackedScene=preload("res://UI_item/product_UI/porduct_label.tscn")

func _on_add_button_down() -> void:
	var input=$project_data_box.get_data()
	if input is Array:
		var optic=Products.optics.new(input[0],input[2],input[1])
		if optic.varify() is String:
			pass
		else:
			optic.initiate()
			$cover/head_line2/ScrollContainer/VBoxContainer.input_optics(optic)


			
		