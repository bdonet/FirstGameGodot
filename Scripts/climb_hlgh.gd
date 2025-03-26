extends Sprite2D

@onready var animation_player = $AnimationPlayer

func fade_and_kill():
	animation_player.play("fade_out")
