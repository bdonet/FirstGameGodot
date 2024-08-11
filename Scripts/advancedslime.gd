extends CharacterBody2D

const ATTACK_SPEED = 125
const PATROL_SPEED = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1
@onready var ray_cast_wall_right = $RayCastWallRight
@onready var ray_cast_wall_left = $RayCastWallLeft
@onready var ray_cast_ledge_right = $RayCastLedgeRight
@onready var ray_cast_ledge_left = $RayCastLedgeLeft
@onready var scout_ray_cast_right = $ScoutRayCastRight
@onready var scout_ray_cast_left = $ScoutRayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

var speed = 0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Turn when facing a wall or ledge
	if ray_cast_wall_right.is_colliding() or !ray_cast_ledge_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_wall_left.is_colliding() or !ray_cast_ledge_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	# Check for a player nearby
	if (scout_ray_cast_left.is_colliding() and direction < 0 or scout_ray_cast_right.is_colliding() and direction > 0):
		speed = ATTACK_SPEED
	else:
		speed = PATROL_SPEED
	
	# Move the slime
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

