extends Node

var score = 0
var apples = 0
var deaths = 0

@onready var score_label = $"../CanvasLayer/RightScoreboard/ScoreLabel"
@onready var coins = $"../Coins"
@onready var maxScore = coins.get_child_count()
@onready var apple_scoreboard = $"../CanvasLayer/RightScoreboard/ScoreLabel/AppleControl/AppleImage"
@onready var score_summary = $"../Labels/ScoreSummary"
@onready var death_timer = $DeathTimer
@onready var player = $"../Player"
@onready var apple = $"../Apple"
@onready var death_label = $"../CanvasLayer/LeftScoreboard/DeathLabel"
@onready var apple_platform_animation_player = $"../Platforms/ApplePlatform/AnimationPlayer"

func add_point():
	score += 1
	setScoreLabelText()


func _on_ready():
	setScoreLabelText()


func setScoreLabelText():
	score_label.text = "x" + str(score)
	score_summary.text = "Coins: " + str(score) + "/" + str(maxScore) + "\nApples: " + str(apples) + "/1"
	
func setDeathLabelText():
	death_label.text = "x" + str(deaths)

func _on_apple_pickup():
	apples += 1
	apple_scoreboard.visible = true
	setScoreLabelText()

func _on_coins_pickup():
	add_point()

func _on_player_died():
	if (!player.is_dead):
		# Wait a bit for a death scene
		Engine.time_scale = 0.5
		death_timer.start()
		
		print("You died!")
		player.kill()
		deaths += 1
		setDeathLabelText()

func _on_death_timer_timeout():
	# Make time move normally again
	Engine.time_scale = 1
	
	# Reset player
	player.revive()

func _on_checkpoint_reached(checkpoint_position):
	player.save_checkpoint(checkpoint_position)
	print("Checkpoint reached")


func _on_apple_platform_player_boarded():
	if apples > 0:
		player.freeze()
		apple_platform_animation_player.play("roll_credits")
