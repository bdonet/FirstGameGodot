extends AnimatableBody2D

signal player_boarded

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_detection_area_player_entered():
	player_boarded.emit()
