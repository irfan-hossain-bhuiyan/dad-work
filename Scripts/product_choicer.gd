extends ScrollContainer
signal out_button(opt_data)

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

		
