extends Area2D

var enemy_detected = false



func _on_body_entered(body):
	enemy_detected = true


func _on_body_exited(body):
	enemy_detected = false
