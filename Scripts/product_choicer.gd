extends ScrollContainer
signal out_button(opt_data)
var button_obj=preload("res://UI_item/product_button.tscn")
func input_data():
	for x in Products.optics_list:
		var temp=button_obj.instance()
		$VBoxContainer.add_child(temp)
		temp.use_optics(x)
		temp.connect("press_with_data",self,"button_pressed")
		var output=yield(self,"out_button")
		return output
func button_pressed(optics_data):
	emit_signal("out_button",optics_data)

		
