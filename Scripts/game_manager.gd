extends Node

var score = 0
var hasApple = false
@onready var score_label = $"../CanvasLayer/MarginContainer/ScoreLabel"
@onready var coins = $"../Coins"
@onready var maxScore = coins.get_child_count()
@onready var apple_image = $"../CanvasLayer/MarginContainer/ScoreLabel/AppleControl/AppleImage"

func add_point():
	score += 1
	setScoreLabelText()


func _on_ready():
	setScoreLabelText()


func setScoreLabelText():
	score_label.text = "x" + str(score)


func _on_apple_pickup():
	hasApple = true
	apple_image.visible = true
