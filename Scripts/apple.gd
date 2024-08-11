extends Area2D

@onready var animation_player = $AnimationPlayer

signal pickup


func _on_body_entered(_body):
	pickup.emit()
	animation_player.play("pickup")
