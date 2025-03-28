extends Area2D


signal player_hit_enemy

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D


func apply(new_position, new_flip_h):
	position = new_position
	sprite_2d.flip_h = new_flip_h
	if (new_flip_h):
		sprite_2d.position.x *= -1
		collision_shape_2d.position.x *= -1


func _on_body_entered(_body):
	print("Hit an enemy")
	player_hit_enemy.emit(_body)


func fade_and_kill():
	animation_player.play("fade_out")
