extends CharacterBody2D

const SPEED = 112.0
const JUMP_VELOCITY = -190.0
const LOW_CLIMB_VELOCITY = -230.0
const HIGH_CLIMB_VELOCITY = -320.0

var is_dead = false
var jumpSaved = false
var climbSaved = ClimbType.None
var can_move = true
var start_position

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
@onready var area_level_1_right_save = $AreaLevel1RightSave
@onready var area_level_1_left_save = $AreaLevel1LeftSave
@onready var area_level_2_right_save = $AreaLevel2RightSave
@onready var area_level_2_left_save = $AreaLevel2LeftSave
@onready var area_level_3_right_save = $AreaLevel3RightSave
@onready var area_level_3_left_save = $AreaLevel3LeftSave
@onready var climb_indicator = $ClimbIndicator

# Save the starting position so we know where to reset to on death	
func _on_ready():
	start_position = position

func freeze():
	can_move = false

func kill():
	can_move = false
	is_dead = true
	animated_sprite.play("death")

func revive():
	can_move = true
	is_dead = false
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
		
		# Remove the climb indicator
		climb_indicator.visible = false
		
		# Play animations
		if not is_dead:
			if is_on_floor():
				animated_sprite.play("idle")
			else:
				animated_sprite.play("jump")
	else:
		# Get the direction of movement. Can be -1, 0, or 1
		var direction = Input.get_axis("move_left", "move_right")
		
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
			
		# Handle climb
		if Input.is_action_just_pressed("jump") or climbSaved == ClimbType.SaveRight or climbSaved == ClimbType.SaveLeft:
			jumpSaved = false
			var climbType = GetClimbType()
			if climbType == ClimbType.RightLow:
				velocity.y = LOW_CLIMB_VELOCITY
				climbSaved = ClimbType.None
			elif climbType == ClimbType.LeftLow:
				velocity.y = LOW_CLIMB_VELOCITY
				climbSaved = ClimbType.None
			elif climbType == ClimbType.RightHigh:
				velocity.y = HIGH_CLIMB_VELOCITY
				climbSaved = ClimbType.None
			elif climbType == ClimbType.LeftHigh:
				velocity.y = HIGH_CLIMB_VELOCITY
				climbSaved = ClimbType.None
				
		# Handle climb just before valid climbing
		if Input.is_action_just_pressed("jump") and !is_on_floor() and (GetClimbType() == ClimbType.SaveRight or GetClimbType() == ClimbType.SaveLeft):
			climbSaved = GetClimbType()
		
		# Reset climb saving when on ground
		if is_on_floor():
			climbSaved = ClimbType.None
			
		# Flip the sprite to face the current direction
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
			
		# Display an indicator if a climb is possible
		var currentClimbType = GetClimbType()
		if (currentClimbType == ClimbType.None or currentClimbType == ClimbType.SaveRight or currentClimbType == ClimbType.SaveLeft):
			climb_indicator.visible = false
		else:
			climb_indicator.visible = true
			if (currentClimbType == ClimbType.RightLow or currentClimbType == ClimbType.RightHigh):
				climb_indicator.offset = Vector2(6, 0)
			else:
				climb_indicator.offset = Vector2(-6, 0)
		
		# Move the player
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta * 9)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 8)

	# Apply the movement to the player
	move_and_slide()
	
enum ClimbType {
	None,
	RightLow,
	LeftLow,
	RightHigh,
	LeftHigh,
	SaveRight,
	SaveLeft
}
	
func GetClimbType():
	if area_level_1_right.isColliding and !area_level_2_right.isColliding and animated_sprite.flip_h == false:
		return ClimbType.RightLow
	elif area_level_1_left.isColliding and !area_level_2_left.isColliding and animated_sprite.flip_h == true:
		return ClimbType.LeftLow
	elif area_level_2_right.isColliding and !area_level_3_right.isColliding and animated_sprite.flip_h == false:
		return ClimbType.RightHigh
	elif area_level_2_left.isColliding and !area_level_3_left.isColliding and animated_sprite.flip_h == true:
		return ClimbType.LeftHigh
	elif area_level_1_right_save.isColliding or area_level_2_right_save.isColliding or area_level_3_right_save.isColliding:
		return ClimbType.SaveRight
	elif area_level_1_left_save.isColliding or area_level_2_left_save.isColliding or area_level_3_left_save.isColliding:
		return ClimbType.SaveLeft
		
	return ClimbType.None
