var optics_list=[]
var optics_name_list:PoolStringArray=[]
var sell_list_data=[]
var buy_list_data=[]
#TODO:Change pro_amo.y in every for loop to amount variable
#func file_load():
#	var save_file:File=File.new()
#	if save_file.file_exists("%APPDATA%/inventory_app/save.txt"):
#		save_file.open("%APPDATA%/inventory_app/save.txt",_File.READ)
#		data_importer(save_file.get_line())
#		save_file.close()
#	else:
#		save_file.open("%APPDATA%/inventory_app/save.txt",_File.WRITE)
#		save_file.close()	
#func file_save():
#	var save_file:File=File.new()
#	save_file.open("%APPDATA%/inventory_app/save.txt",_File.WRITE)
#	save_file.store_line(data_exporter())
#	save_file.close()

func data_importer(output):
	#NOTE:data_importer will erase all the previous data
	optics_list.clear()
	sell_list_data.clear()
	buy_list_data.clear()
	for x in output["optics_list"]:
		var optic=optics._import(x)
		optics_list.append(optic)
	for x in output["sell_data_list"]:
		var sell=sell_list._import(x)
		sell_list_data.append(sell)
	for x in output["optics_list"]:
		var buy=buy_list._import(x)
		buy_list_data.append(buy)
	

func data_exporter()->String:
	var output={"optics_list":[],
	"sell_list_data":[],
	"buy_list_data":[]}
	for optics in optics_list:
		output["optics_list"].append(optics._export)
	for sell_data in sell_list_data:
		output["sell_list_data"].append(sell_data._export)
	for buy_data in buy_list_data:
		output["buy_list_data"].append(buy_data._export)
	return parse_json(output)
class sell_list:
	var products_amounts:PoolVector2Array
	var total_cost:int
	var money:int
	var date_time:Dictionary
	func _init(products_amounts:PoolVector2Array,money:int):
		self.products_amounts=products_amounts
		self.total_cost=total_cost
		
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
			var obj:sell_list=sell_list.new(products_amounts,total_cost,paid_money,OS.get_datetime())
			Products.sell_list_data.append(obj)
			return obj
	func varify():
		var total_cost:int=0
		for pro_amo in products_amounts:
			var product:=Products.optics_list[pro_amo.x] as optics
			if pro_amo.y>product.amount:
				return "you are out of stock."
			total_cost+=product.amount*pro_amo.y
			
		if paid_money>total_cost:
			return "you are losting money."
		return total_cost
	func initiate():
		var check=varify()
		if check is int:
			for pro_amo in products_amounts:
				var product:=Products.optics_list[pro_amo.x] as optics
				product.amount-=pro_amo.y
			
			
		
		Products.sell_list_data.append(self)

	func _export():
		return [products_amounts,total_cost,money,date_time]
	static func _import(array:Array):
		if len(array)!=4:
			return "Import sell_list wasn't working"
		else:
			var output:=sell_list.new(array[0],array[1],array[2],array[3])
			return output
	
class buy_list:
	var products_amounts:PoolVector2Array
	var total_cost:int
	var date_time:Dictionary
	func _init(products_amounts:PoolVector2Array):
		self.products_amounts=products_amounts

	func verify():
		var total_cost:int=0
		for pro_amo in products_amounts:
			var product:=Products.optics_list[pro_amo.x] as optics
			if product.amount+pro_amo.y>product.Max_stock:
				return "doesn't have max storage for "+product.Name
			total_cost+=product.buy_price*pro_amo.y
		return total_cost
	func initiate():
		var check=verify()
		if check is int:
			for pro_amo in products_amounts:
				var product:=Products.optics_list[pro_amo.x] as optics
				productamount+=pro_amo.y
			total_cost=check
			date_time=OS.get_datetime()
			Products.buy_list_data.append(self)
		else:
			return check
	
	func _export():
		return [products_amounts,total_cost,date_time]
	static func _import(array:Array):
		if len(array)!=3:
			return "Import buy_list wasn't working"
		else:
			var output:=buy_list.new(array[0])
			output.date_time=array[2]
			output.total_cost=array[1]
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
		return [Name,Max_stock,buy_price,amount]
	static	func _import(array:Array):
		if len(array)!=5:
			return "Import optics wasn't working"
		else:
			var output:=optics.new(array[0],array[1],array[2],array[3])
			return output

