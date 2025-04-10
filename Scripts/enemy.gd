extends CharacterBody2D
class_name Enemy


const SPEED = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var stun_timer = $StunTimer

signal player_died
signal enemy_died

var canMove = true
var canAttack = true
var health = 1


func _on_killzone_player_died():
	if (canAttack):
		player_died.emit()


func stun():
	freeze()
	health -= 1
	if (health <= 0):
		kill()
	else:
		stun_timer.start()


func kill():
	enemy_died.emit()


func freeze():
	velocity.x = 0
	canMove = false
	canAttack = false


func unfreeze():
	canMove = true
	canAttack = true


func _on_stun_timer_timeout():
	unfreeze()
