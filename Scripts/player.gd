extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -250.0

var isDead = false
var jumpSaved = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_ray_cast_right = $CoyoteRayCastRight
@onready var coyote_ray_cast_left = $CoyoteRayCastLeft
@onready var jump_save_ray_cast = $JumpSaveRayCast
@onready var area_level_1_right = $AreaLevel1Right
@onready var area_level_1_left = $AreaLevel1Left
@onready var area_level_2_right = $AreaLevel2Right
@onready var area_level_2_left = $AreaLevel2Left
@onready var area_level_3_right = $AreaLevel3Right
@onready var area_level_3_left = $AreaLevel3Left

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
		if (Input.is_action_just_pressed("jump") or jumpSaved) and (is_on_floor() or (coyote_ray_cast_left.is_colliding() and direction > 0) or (coyote_ray_cast_right.is_colliding() and direction < 0)):
			velocity.y = JUMP_VELOCITY
			jumpSaved = false
			
		# Handle jump just before hitting ground
		if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_save_ray_cast.is_colliding() and velocity.y > 0:
			jumpSaved = true
			
		# Handle short climb
		if Input.is_action_just_pressed("climb"):
			if area_level_1_right.isColliding and !area_level_2_right.isColliding and direction >= 0:
				position.y += -16
				position.x += 8
			elif area_level_1_left.isColliding and !area_level_2_left.isColliding and direction <= 0:
				position.y += -16
				position.x += -8
			
		# Flip the sprite to face the current direction
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Move the player
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta * 9)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 8)

	# Apply the movement to the player
	move_and_slide()
