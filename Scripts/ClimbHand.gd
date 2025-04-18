extends Sprite2D

var original_rotation


# Called when the node enters the scene tree for the first time.
func _ready():
	original_rotation = rotation_degrees


func unmirror():
	flip_h = false
	position.x = abs(position.x)
	rotation_degrees = original_rotation


func mirror():
	flip_h = true
	position.x = -abs(position.x)
	rotation_degrees = -original_rotation
