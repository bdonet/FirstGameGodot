extends Node

var score = 0
@onready var score_label = $"../CanvasLayer/MarginContainer/ScoreLabel"
@onready var coins = $"../Coins"
@onready var maxScore = coins.get_child_count()

func add_point():
	score += 1
	setScoreLabelText()


func _on_ready():
	setScoreLabelText()


func setScoreLabelText():
	score_label.text = "Coins:\n" + str(score) + "/" + str(maxScore)
