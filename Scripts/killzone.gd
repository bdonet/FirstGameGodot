extends Area2D

signal player_died

func _on_body_entered(_body):
	player_died.emit()
