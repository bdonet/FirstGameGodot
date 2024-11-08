extends Area2D

signal player_fell

func _on_body_entered(_body):
	print("test")
	player_fell.emit()
