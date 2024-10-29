extends Node

signal pickup
signal coin_names_built


func _on_coin_pickup(coin_name):
	pickup.emit(coin_name)


func _on_ready():
	var coin_names = ""
	for child in get_children(true):
		child.connect("pickup", _on_coin_pickup)
		coin_names += "\n" + child.name + ","
	
	
	coin_names_built.emit(coin_names)
