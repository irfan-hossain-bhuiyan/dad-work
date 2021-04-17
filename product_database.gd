extends Node2D
var optics_list=[]
var optics_name_list:PoolStringArray=[]
var sell_list_data=[]
var buy_list_data=[]
#TODO:Change pro_amo.y in every for loop to amount variable
func file_load():
	var save_file:File=File.new()
	if save_file.file_exists("%APPDATA%/inventory_app/save.txt"):
		save_file.open("%APPDATA%/inventory_app/save.txt",_File.READ)
		data_importer(save_file.get_line())
	else:
		save_file.open("%APPDATA%/inventory_app/save.txt",_File.WRITE)
		save_file.close()	
func file_save():
	var save_file:File=File.new()
	save_file.open("%APPDATA%/inventory_app/save.txt",_File.WRITE)
	save_file.store_line(data_exporter())

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
	func _init(products_amounts:PoolVector2Array,total_cost:int,money:int,date_time:Dictionary):
		self.products_amounts=products_amounts
		self.total_cost=total_cost
		self.money=money
		self.date_time=date_time
		
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
	func _init(products_amounts:PoolVector2Array,total_cost:int,date_time:Dictionary):
		self.products_amounts=products_amounts
		self.total_cost=total_cost
		self.date_time=date_time

	static func create(products_amounts:PoolVector2Array):
		var total_cost:int=0
		for pro_amo in products_amounts:
			var product:=Products.optics_list[pro_amo.x] as optics
			if product.amount+pro_amo.y>product.Max_stock:
				return "doesn't have max storage."
			total_cost+=product.buy_price*pro_amo.y
		var output=buy_list.new(products_amounts,total_cost,OS.get_datetime())
		Products.buy_list_data.append(output)
		return output
	func _export():
		return [products_amounts,total_cost,date_time]
	static func _import(array:Array):
		if len(array)!=3:
			return "Import buy_list wasn't working"
		else:
			var output:=buy_list.new(array[0],array[1],array[2])
			return output

class optics:
	var Name:String
	var Max_stock:int
	var buy_price:int
	var product_id:int
	var amount:int=0
	func _init(Name:String,Max_stock:int,buy_price:int,product_id:int,amount:int=0):
		self.Name=Name
		self.Max_stock=Max_stock
		self.buy_price=buy_price
		self.product_id=product_id
		self.amount=amount


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
			var optical_product=optics.new(name,max_stock,buy_price,len(optics))
			Products.optics_name_list.append(name)
			Products.optics_list.append(optical_product)
			return optical_product
		return output
	func _export():
		return [Name,Max_stock,buy_price,amount,product_id]
	static	func _import(array:Array):
		if len(array)!=5:
			return "Import optics wasn't working"
		else:
			var output:=optics.new(array[0],array[1],array[2],array[3],array[4])
			return output

