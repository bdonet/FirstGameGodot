extends Enemy

const ATTACK_SPEED = 112
const PATROL_SPEED = 50
const MAX_HEALTH = 3

var direction = 1
var speed = 0

@onready var ray_cast_wall = $RayCastWall
@onready var scout_ray_cast = $ScoutRayCast
@onready var ray_cast_ledge = $RayCastLedge
@onready var animated_sprite = $AnimatedSprite2D


func _on_ready():
	health = MAX_HEALTH

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (canMove):
		# Turn when facing a wall or ledge
		if ray_cast_wall.is_colliding() or !ray_cast_ledge.is_colliding():
			direction *= -1
			animated_sprite.flip_h = not animated_sprite.flip_h
			ray_cast_ledge.target_position.x *= -1
			ray_cast_ledge.position.x *= -1
			ray_cast_wall.target_position.x *= -1
			scout_ray_cast.target_position.x *= -1
			
		# Check for a player nearby
		if (scout_ray_cast.is_colliding()):
			speed = ATTACK_SPEED
		else:
			speed = PATROL_SPEED
		
		# Move the slime
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func stun():
	animated_sprite.play("stun")
	super.stun()


func unfreeze():
	animated_sprite.play("default")
	super.unfreeze()
