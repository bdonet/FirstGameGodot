extends Area2D

var enemy_detected = false



func _on_body_entered(_body):
	enemy_detected = true


func _on_body_exited(_body):
	enemy_detected = false


func mirror():
	position.x = -abs(position.x)


func unmirror():
	position.x = abs(position.x)
