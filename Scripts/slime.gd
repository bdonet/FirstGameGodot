extends CharacterBody2D

const SPEED = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

@onready var ray_cast_wall = $RayCastWall
@onready var ray_cast_ledge = $RayCastLedge
@onready var animated_sprite = $AnimatedSprite2D
@onready var stun_timer = $StunTimer

signal player_died

var canMove = true
var canAttack = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (canMove):
		if ray_cast_wall.is_colliding() or !ray_cast_ledge.is_colliding():
			direction *= -1
			animated_sprite.flip_h = not animated_sprite.flip_h
			ray_cast_wall.target_position.x *= -1
			ray_cast_ledge.target_position.x *= -1
			ray_cast_ledge.position.x *= -1
			
		# Move the player
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_killzone_player_died():
	if (canAttack):
		player_died.emit()


func stun():
	freeze()
	stun_timer.start()
	animated_sprite.play("stun")


func freeze():
	canMove = false
	canAttack = false
	velocity.x = 0


func unfreeze():
	canMove = true
	canAttack = true


func _on_stun_timer_timeout():
	unfreeze()
	animated_sprite.play("default")
