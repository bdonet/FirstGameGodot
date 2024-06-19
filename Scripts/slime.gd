extends CharacterBody2D

const SPEED = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1
@onready var ray_cast_wall_right = $RayCastWallRight
@onready var ray_cast_wall_left = $RayCastWallLeft
@onready var ray_cast_ledge_right = $RayCastLedgeRight
@onready var ray_cast_ledge_left = $RayCastLedgeLeft
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if ray_cast_wall_right.is_colliding() or !ray_cast_ledge_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_wall_left.is_colliding() or !ray_cast_ledge_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	# Move the player
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# position.x += direction * SPEED * delta
