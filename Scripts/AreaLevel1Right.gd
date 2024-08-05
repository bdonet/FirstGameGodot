extends Area2D

var isColliding = false
@onready var collision_display = $CollisionDisplay

func _on_body_entered(body):
	isColliding = true
	$CollisionDisplay.visible = !isColliding
	

func _on_body_exited(body):
	isColliding = false
	$CollisionDisplay.visible = !isColliding
