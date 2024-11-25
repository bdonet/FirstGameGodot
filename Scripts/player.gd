extends CharacterBody2D

const SPEED = 115.0
const LONG_JUMP_BONUS = 50.0
const JUMP_VELOCITY = -150.0
const LOW_CLIMB_VELOCITY = -230.0
const HIGH_CLIMB_VELOCITY = -320.0
const HORIZONTAL_ACCELERATION_MULTIPLIER = 9
const HORIZONTAL_DECELERATION_MULTIPLIER = 8

var is_dead = false
var is_invincible = false
var is_rolling = false
var is_long_jumping = false
var jump_saved = false
var long_jump_saved = false
var climb_saved = false
var can_move = true
var can_long_jump = false
var rolling_direction
var start_position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_ray_cast = $CoyoteRayCast
@onready var area_level_1 = $AreaLevel1
@onready var area_level_2 = $AreaLevel2
@onready var area_level_3 = $AreaLevel3
@onready var jump_save_timer = $JumpSaveTimer
@onready var long_jump_save_timer = $LongJumpSaveTimer
@onready var climb_save_timer = $ClimbSaveTimer

# Save the starting position so we know where to reset to on death	
func _on_ready():
	start_position = position

func freeze():
	can_move = false
	is_rolling = false
	is_long_jumping = false
	reset_saved_moves()

func kill():
	can_move = false
	is_dead = true
	is_invincible = true
	is_rolling = false
	is_long_jumping = false
	reset_saved_moves()
	animated_sprite.play("death")

func revive():
	can_move = true
	is_dead = false
	is_invincible = false
	position = start_position

func save_checkpoint(checkpoint_position):
	start_position = checkpoint_position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not can_move:
		# Stop the player
		velocity.x = 0
		
		# Play animations
		if not is_dead and not is_rolling:
			if is_on_floor():
				animated_sprite.play("idle")
			else:
				animated_sprite.play("jump")
	else:
		# Get the direction of movement. Can be -1, 0, or 1
		var direction = Input.get_axis("move_left", "move_right")
		
		if is_rolling:
			if Input.is_action_just_pressed("jump"):
				long_jump_saved = true
				print("long jump saved")
		else:
			# Play continuous animations
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			
			# Stop long jumping, if applicable
			if is_on_floor():
				is_long_jumping = false
			
			if area_level_1.isColliding:
				is_long_jumping = false
				
			# Handle long jumping
			if (long_jump_saved or (Input.is_action_just_pressed("jump") and can_long_jump)) and can_jump():
				long_jump()
			
			# Handle jump
			if (Input.is_action_just_pressed("jump") or jump_saved) and can_jump():
				velocity.y = JUMP_VELOCITY
				animated_sprite.play("jump")
				print("Jumped")
				jump_saved = false
				climb_saved = false
				
			# Handle jump just before hitting ground
			if Input.is_action_just_pressed("jump") and !can_jump() and velocity.y > 0:
				jump_saved = true
				print("jump saved")
				jump_save_timer.start()
				
			# Handle climb
			if Input.is_action_just_pressed("climb") or climb_saved:
				var climbType = GetClimbType()
				if climbType == ClimbType.Low:
					velocity.y = LOW_CLIMB_VELOCITY
					climb_saved = false
					jump_saved = false
					animated_sprite.play("climb_low")
					print("Climbed low")
				elif climbType == ClimbType.High:
					velocity.y = HIGH_CLIMB_VELOCITY
					climb_saved = false
					jump_saved = false
					animated_sprite.play("climb_high")
					print("Climbed high")
					
			# Handle climb just before valid climbing
			if Input.is_action_just_pressed("climb") and !is_on_floor() and (GetClimbType() == ClimbType.None):
				climb_saved = true
				print("climb saved")
				climb_save_timer.start()
			
			# Reset climb saving when on ground
			if is_on_floor():
				climb_saved = false
			
			# Handle roll
			if Input.is_action_just_pressed("roll"):
				is_invincible = true
				is_rolling = true
				
				if animated_sprite.flip_h:
					rolling_direction = -1
				else:
					rolling_direction = 1
				
				animated_sprite.play("roll")
				
			# Flip the sprites and movement objects to face the current direction
			if direction > 0:
				animated_sprite.flip_h = false
				coyote_ray_cast.target_position.x = -abs(coyote_ray_cast.target_position.x)
				area_level_1.position.x = abs(area_level_1.position.x)
				area_level_2.position.x = abs(area_level_2.position.x)
				area_level_3.position.x = abs(area_level_3.position.x)
			elif direction < 0:
				animated_sprite.flip_h = true
				coyote_ray_cast.target_position.x = abs(coyote_ray_cast.target_position.x)
				area_level_1.position.x = -abs(area_level_1.position.x)
				area_level_2.position.x = -abs(area_level_2.position.x)
				area_level_3.position.x = -abs(area_level_3.position.x)
		
		# Move the player
		if is_rolling:
			velocity.x = move_toward(velocity.x, rolling_direction * SPEED, SPEED * delta * HORIZONTAL_ACCELERATION_MULTIPLIER)
		elif is_long_jumping:
			velocity.x = rolling_direction * (SPEED + LONG_JUMP_BONUS)
		elif direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta * HORIZONTAL_ACCELERATION_MULTIPLIER)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * HORIZONTAL_DECELERATION_MULTIPLIER)

	# Apply the movement to the player
	move_and_slide()
	
enum ClimbType {
	None,
	Low,
	High
}
	
func GetClimbType():
	if area_level_1.isColliding and !area_level_2.isColliding:
		return ClimbType.Low
	elif area_level_2.isColliding and !area_level_3.isColliding:
		return ClimbType.High
		
	return ClimbType.None


func _on_jump_save_timer_timeout():
	jump_saved = false
	print("Jump expired")


func _on_climb_save_timer_timeout():
	climb_saved = false
	print("Climb expired")


func _on_long_jump_save_timer_timeout():
	can_long_jump = false
	print("Long jump expired")

func _on_animated_sprite_2d_animation_finished():
	if is_rolling:
		is_invincible = false
		is_rolling = false
		can_long_jump = true
		long_jump_save_timer.start()

func long_jump():
	velocity.y = JUMP_VELOCITY
	animated_sprite.play("jump")
	print("Long jumped")
	is_long_jumping = true
	reset_saved_moves()
	
func reset_saved_moves():
	long_jump_saved = false
	jump_saved = false
	climb_saved = false
	
func can_jump():
	return is_on_floor() or coyote_ray_cast.is_colliding()
