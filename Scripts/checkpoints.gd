extends Node

signal checkpoint_reached

func _on_checkpoint(position):
	checkpoint_reached.emit(position)

func _on_ready():
	for child in get_children(true):
		child.checkpoint_reached.connect(_on_checkpoint)
