extends Node2D
func _ready():
	print("Start")
	print(Products.optics.new("A",20,100).initiate())
	print(Products.optics.new("B",10,50).initiate())
	print(Products.optics.new("A",20,100).initiate())
	print(Products.optics.new("C",15,10).initiate())
	print(Products.buy_list.new([Vector2(0,10),Vector2(1,5),Vector2(2,7)]).initiate())
	print(Products.sell_list.new([Vector2(0,10),Vector2(1,5),Vector2(2,5)],12950).initiate())
	Products.file_save()
	for x in Products.optics_list:
		prints(x.Name,x.amount)

		
