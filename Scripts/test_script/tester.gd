extends "res://Scripts/product_database.gd"
func _ready() -> void:
	print(optics.new("A",10,50).initiate())
	print(optics.new("B",5,10).initiate())
	print(optics.new("C",15,30).initiate())
	print(optics.new("D",20,40).initiate())
	print(optics.new("A",100,2).initiate())
	var pro_amo1:=product_amount.new()
	pro_amo1.add_data(0,5)
	pro_amo1.add_data(1,5)
	pro_amo1.add_data(2,10)
	var buy:=buy_list.new(pro_amo1)
	buy.initiate()
	sell_list.new(pro_amo1,1000).initiate()
	print(sell_list.new(pro_amo1,1000).initiate())
	file_save()
	debug_print()
	
	


	

	
	
	

