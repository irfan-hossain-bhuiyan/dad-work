extends Node2D
class_name Products
var optics_list=[]
var optics_name_list:PoolStringArray=[]
class optics:
	var Name:String
	var Max_stock:int
	var buy_price:int
	var amount:=0
	var product_id:int
	func add_in(add_amount)->String:
		if Max_stock<amount+add_amount:
			return "Sorry,but the there isnot enough space"
		else:
			amount+=add_amount
			return ""
	func sell(amount:int,total_money:int)->int:
		var earn:int=total_money-amount*buy_price
		return earn

func create(name:String,max_stock:int,buy_price:int):
	var output:String=""
	var error=0
	if name in optics_name_list:
		output+="name has been added previously/n"
		error+=1
	if max_stock<=0:
		output+="max_stock is 0 or less/n"
		error+=1
	if buy_price<=0:
		output+="sell price can't be negative"
		error+=1
	if error==0:
		var optical_product=optics.new()
		optical_product.Name=name
		optics_name_list.append(name)
		optical_product.product_id=len(optics)
		optical_product.buy_price=buy_price
		optics_list.append(optical_product)
		return optical_product
	return output

	
	
	
