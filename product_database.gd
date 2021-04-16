extends Node2D
var optics_list=[]
var optics_name_list:PoolStringArray=[]
var sell_list_data=[]
var buy_list_data=[]
class sell_list:
	var products_amounts:PoolVector2Array
	var total_cost:int
	var money:int
	var date_time:Dictionary
	static func create(products_amounts:PoolVector2Array,paid_money:int):
		var total_cost:int=0
		for pro_amo in products_amounts:
			var product:=Products.optics_list[pro_amo.x] as optics
			if pro_amo.y>product.amount:
				return "you are out of stock."
			total_cost+=product.amount*pro_amo.y
		if paid_money>total_cost:
			return "you are losting money."
		else:
			for pro_amo in products_amounts:
				var product:=Products.optics_list[pro_amo.x] as optics
				product.amount-=pro_amo.y
			var obj:sell_list=sell_list.new()
			obj.products_amounts=products_amounts
			obj.total_cost=total_cost
			obj.date_time=OS.get_datetime
			Products.sell_list_data.append(obj)
			return obj
	
class buy_list:
	var products_amounts:PoolVector2Array
	var total_cost:int
	var date_time:Dictionary
	static func create():
		pass


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

	static func create(name:String,max_stock:int,buy_price:int):
		var output:String=""
		var error=0
		if name in Products.optics_name_list:
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
			Products.optics_name_list.append(name)
			optical_product.product_id=len(optics)
			optical_product.buy_price=buy_price
			Products.optics_list.append(optical_product)
			return optical_product
		return output

	
	
	
