extends VBoxContainer
var button_label:PackedScene=preload("res://UI_item/product_UI/porduct_label.tscn")
func input_datalist():
	#FIXME:Can caught bug because of changing it
	for x in get_children():
		x.queue_free()
	for x in Products.optics_list:
		input_data(x)

func input_data(x):
	var temp=button_label.instance()
	add_child(temp)
	temp.use_optics(x)




