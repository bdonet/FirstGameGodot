extends Enemy


var direction = 1

@onready var ray_cast_wall = $RayCastWall
@onready var ray_cast_ledge = $RayCastLedge
@onready var animated_sprite = $AnimatedSprite2D


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


func stun():
	animated_sprite.play("stun")
	super.stun()


func unfreeze():
	animated_sprite.play("default")
	super.unfreeze()
