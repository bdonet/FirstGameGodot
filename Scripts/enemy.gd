extends CharacterBody2D
class_name Enemy


const SPEED = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var stun_timer = $StunTimer

signal player_died

var canMove = true
var canAttack = true


func _on_killzone_player_died():
	if (canAttack):
		player_died.emit()


func stun():
	freeze()
	velocity.x = 0
	stun_timer.start()


func freeze():
	canMove = false
	canAttack = false


func unfreeze():
	canMove = true
	canAttack = true


func _on_stun_timer_timeout():
	unfreeze()
