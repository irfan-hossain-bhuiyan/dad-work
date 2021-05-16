extends Node
func _ready() -> void:
	print("start")
	print(Products.optics.new("A",10,50).initiate())
	print(Products.optics.new("B",5,10).initiate())
	print(Products.optics.new("C",15,30).initiate())
	print(Products.optics.new("D",20,40).initiate())
	print(Products.optics.new("A",100,2).initiate())
	var pro_amo1:=Products.product_amount.new()
	pro_amo1.add_data(0,5)
	pro_amo1.add_data(1,5)
	pro_amo1.add_data(2,10)
	var buy:=Products.buy_list.new(pro_amo1)
	buy.initiate()
	Products.sell_list.new(pro_amo1,1000).initiate()
	print(Products.sell_list.new(pro_amo1,1000).initiate())
	Products.file_save()
	Products.debug_print()


