extends Area2D

signal checkpoint_reached

func _on_body_entered(_body):
	checkpoint_reached.emit(position)
