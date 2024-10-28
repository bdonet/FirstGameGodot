extends Node

var score = 0
var apples = 0
@onready var score_label = $"../CanvasLayer/MarginContainer/ScoreLabel"
@onready var coins = $"../Coins"
@onready var maxScore = coins.get_child_count()
@onready var apple_scoreboard = $"../CanvasLayer/MarginContainer/ScoreLabel/AppleControl/AppleImage"
@onready var score_summary = $"../Labels/ScoreSummary"
@onready var death_timer = $DeathTimer
@onready var player = $"../Player"
@onready var apple = $"../Apple"

func add_point():
	score += 1
	setScoreLabelText()


func _on_ready():
	setScoreLabelText()


func setScoreLabelText():
	score_label.text = "x" + str(score)
	score_summary.text = "Coins: " + str(score) + "/" + str(maxScore) + "\nApples: " + str(apples) + "/1"


func _on_apple_pickup():
	apples += 1
	apple_scoreboard.visible = true
	setScoreLabelText()

func _on_coins_pickup():
	add_point()

func _on_player_died():
	print("You died!")
	Engine.time_scale = 0.5
	player.isDead = true
	death_timer.start()
	apples = 0
	apple_scoreboard.visible = false
	setScoreLabelText()
	apple.reset()

func _on_death_timer_timeout():
	Engine.time_scale = 1
	player.position.x = player.startX
	player.position.y = player.startY
	player.isDead = false

func _on_checkpoint_reached(checkpoint_position):
	if (apples > 0):
		print("Checkpoint ignored")
		return
	player.startX = checkpoint_position.x
	player.startY = checkpoint_position.y
	print("Checkpoint reached")
