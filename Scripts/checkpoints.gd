extends Node

signal checkpoint_reached

func _on_checkpoint():
	print("checkpoint signal passed")
	checkpoint_reached.emit()

func _on_ready():
	for child in get_children(true):
		child.connect("checkpoint_reached", _on_checkpoint)
