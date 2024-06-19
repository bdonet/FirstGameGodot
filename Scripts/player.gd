extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var isDead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_ray_cast_right = $CoyoteRayCastRight
@onready var coyote_ray_cast_left = $CoyoteRayCastLeft

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	
	# Get the direction of movement. Can be -1, 0, or 1
	var direction = Input.get_axis("move_left", "move_right")
		
	if isDead:
		animated_sprite.play("death")
		velocity.x = 0
	else:
		# Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	
		# Handle jump.
		if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_ray_cast_left.is_colliding() or coyote_ray_cast_right.is_colliding()):
			velocity.y = JUMP_VELOCITY

		# Flip the sprite to face the current direction
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Move the player
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply the movement to the player
	move_and_slide()
