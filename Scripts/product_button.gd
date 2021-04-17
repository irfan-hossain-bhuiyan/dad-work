extends Button
var optil_data:Products.optics
signal press_with_data(optic_data)
func use_optics(optical_data:Products.optics):
	$product_name.text=optical_data.Name
	$pcs.text=optical_data.amount
	$max_amount.text=optical_data.Max_stock
	optil_data=optical_data

	


func _on_product_button_button_down():
	emit_signal("press_with_data",optil_data)

