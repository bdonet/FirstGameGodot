extends Area2D

signal checkpoint_reached

func _on_body_entered(_body):
	print("Checkpoint hit")
	checkpoint_reached.emit()
