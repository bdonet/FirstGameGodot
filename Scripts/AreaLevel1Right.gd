extends Area2D

var isColliding = false

func _on_body_entered(_body):
	isColliding = true
	

func _on_body_exited(_body):
	isColliding = false
