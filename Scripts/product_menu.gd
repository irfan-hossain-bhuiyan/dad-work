extends Control
var button_label:PackedScene=preload("res://UI_item/product_UI/porduct_label.tscn")

func _on_add_button_down() -> void:
	var input=yield($project_data_box.get_data(),"completed")
	if input is Array:
		var optic=Products.optics.new(input[0],input[2],input[1])
		var error=optic.varify()
		if not error.empty():
			ErrorReport.error_message(error)
		else:
			optic.initiate()
			$ScrollContainer/VBoxContainer.input_data(optic)
			


			
		
