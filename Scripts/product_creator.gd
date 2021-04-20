extends ConfirmationDialog
signal output(value)

func get_data():
	popup()
	var out=yield(self,"output")
	return out
func _on_project_data_box_confirmed() -> void:
	emit_signal("output",$input_group.input_data())


func _on_project_data_box_popup_hide() -> void:
	yield(get_tree().create_timer(0.1),"timeout")
	emit_signal("output",0)


