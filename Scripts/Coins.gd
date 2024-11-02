extends Node

signal pickup


func _on_coin_pickup():
	pickup.emit()


func _on_ready():
	for child in get_children(true):
		child.connect("pickup", _on_coin_pickup)
