extends Node
var optics_list=[]
var optics_name_list=[]
var sell_list_data=[]
var buy_list_data=[]
#TODO:Change pro_amo.y in every for loop to amount variable
func file_load():
	var save_file:File=File.new()
	if save_file.file_exists("user://savegame.save"):
		save_file.open("user://savegame.save",File.READ)
		data_importer(parse_json(save_file.get_line()))
		save_file.close()
	else:
		save_file.open("user://savegame.save",File.WRITE)
		save_file.close()	
func file_save():
	var save_file:File=File.new()
	save_file.open("user://savegame.save",File.WRITE)
	save_file.store_line(data_exporter())
	save_file.close()

func data_importer(output):
	#NOTE:data_importer will erase all the previous data
	optics_list.clear()
	sell_list_data.clear()
	buy_list_data.clear()
	for x in output["optics_list"]:
		var optic:optics=optics._import(x)
		optics_name_list.append(optic.Name)
		optics_list.append(optic)
	for x in output["sell_list_data"]:
		var sell:sell_list=sell_list._import(x)
		sell_list_data.append(sell)
	for x in output["buy_list_data"]:
		var buy:buy_list=buy_list._import(x)
		buy_list_data.append(buy)
	

func data_exporter()->String:
	var output={"optics_list":[],
	"sell_list_data":[],
	"buy_list_data":[]}
	for optics in optics_list:
		output["optics_list"].append(optics._export())
	for sell_data in sell_list_data:
		output["sell_list_data"].append(sell_data._export())
	for buy_data in buy_list_data:
		output["buy_list_data"].append(buy_data._export())
	return to_json(output)
class sell_list:
	var products_amounts:product_amount
	var money:int
	var date_time:Dictionary
	func _init(products_amounts:product_amount,money:int):
		self.products_amounts=products_amounts
		self.money=money
	
	func varify():
		var check=products_amounts.sell_varify()
		if check is int:
			if products_amounts.all_price()[-1]> money:
				return "you are losting money."
		return check
	
	func initiate():
		var check=varify()
		if check is int:
			products_amounts.product_sub()
			Products.sell_list_data.append(self)
		return check
		

	func _export():
		return [products_amounts._export(),money,date_time]

	static func _import(array:Array):
		var output:=sell_list.new(array[0]._import(),array[1])
		output.date_time=array[2]
		return output

class buy_list:
	var products_amounts:product_amount
	var date_time:Dictionary
	func _init(products_amounts:product_amount):
		self.products_amounts=products_amounts
	func verify():
		return products_amounts.buy_varify()
	
	func initiate():
		var check=products_amounts.verify()
		if check is int:
			products_amounts.product_add()
			date_time=OS.get_datetime()
			Products.buy_list_data.append(self)
		return check
	
	func _export():
		return [product_amount._export(),date_time]
	static func _import(array:Array)->buy_list:
		var output:=buy_list.new(array[0]._import())
		output.date_time=array[1]
		return output

class optics:
	var Name:String
	var Max_stock:int
	var buy_price:int
	var product_id:int
	var amount:int=0
	func _init(Name:String,Max_stock:int,buy_price:int,amount:int=0):
		self.Name=Name
		self.Max_stock=Max_stock
		self.buy_price=buy_price
		self.amount=amount
	func varify()->String:
		var output=""
		if Name in Products.optics_name_list:
			output+="name has been added previously/n"			
		if Max_stock<=0:
			output+="max_stock is 0 or less/n"
		if buy_price<=0:
			output+="sell price can't be negative"
		return output
	func initiate()->String:
		var error=varify()
		if error.empty():
			product_id=len(Products.optics_list)
			Products.optics_name_list.append(Name)
			Products.optics_list.append(self)
		return error
	
	func _export():
		return [Name,Max_stock,buy_price,amount,product_id]
	static	func _import(array:Array)->optics:
		var output:=optics.new(array[0],array[1],array[2],array[3])
		output.product_id=array[4]
		return output
class product_amount:
	var product_amount_prices:PoolVector3Array
	func add_data(optic:optics,amount:int):
		product_amount_prices.append(Vector3(optic.product_id,amount,optic.buy_price*amount))
	func all_price():
		#This will output all the price with total
		var total:int=0
		var output:PoolIntArray
		for x in product_amount_prices:
			output.append(x.z)
			total+=x.z
		output.append(total)
		return output
	func refresh(id:int):
		var temp=product_amount_prices[id]
		temp.z=Products.optics_list[temp.x]*temp.y

	func refresh_all():
		for x in range(product_amount_prices.size()):
			refresh(x)

	func product_sub():
		var check=sell_varify()
		if check is int:
			#TODO:here it has to be fixed.
			for pro_amo in product_amount_prices:
				var product:=Products.optics_list[pro_amo.x] as optics
				product.amount-=pro_amo.y
		return check

	func product_add():
		var check=buy_varify()
		if check is int:
			#TODO:here it has to be fixed.
			for pro_amo in product_amount_prices:
				var product:=Products.optics_list[pro_amo.x] as optics
				product.amount+=pro_amo.y
		return check


	
	func _export():
		return Array(product_amount_prices)
	static func _import(data:Array):
		var temp=product_amount.new()
		temp.product_amount_prices=PoolVector3Array(data)
		return temp
	func buy_varify():
		for pro_amo in product_amount_prices:
			var product=Products.optics_list[pro_amo.x]
			var amount=pro_amo.y
			if product.amount+amount>product.Max_stock:
				return "doesn't have max storage for "+product.Name
		return 0
	func sell_varify():
		for pro_amo in product_amount_prices:
			var product=Products.optics_list[pro_amo.x]
			var amount=pro_amo.y
			if product.amount<amount:
				return "doesn't have max storage for "+product.Name
		return 0
	func get_product_list():
		var output_array=[]
		for pro in product_amount_prices:
			pro=Products.optics_list[pro.x]
			output_array.append(pro)
		return output_array

