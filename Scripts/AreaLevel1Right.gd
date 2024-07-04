extends Area2D

var isColliding = false

func _on_body_entered(body):
	isColliding = true
	

func _on_body_exited(body):
	isColliding = false
