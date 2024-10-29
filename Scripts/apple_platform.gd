extends AnimatableBody2D

signal player_boarded

var player_hit_upper = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_upper_player_detection_area_player_entered():
	player_hit_upper = true


func _on_lower_player_detection_area_player_entered():
	if (player_hit_upper):
		player_boarded.emit()
