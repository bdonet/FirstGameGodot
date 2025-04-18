extends Area2D

var isColliding = false

func _on_body_entered(_body):
	isColliding = true
	

func _on_body_exited(_body):
	isColliding = false


func mirror():
	position.x = -abs(position.x)


func unmirror():
	position.x = abs(position.x)
