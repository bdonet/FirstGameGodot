extends Node2D

const CLIMB_HIGH = preload("res://Scenes/climb_high.tscn")
const CLIMB_LOW = preload("res://Scenes/climb_low.tscn")
const ATTACK = preload("res://Scenes/attack.tscn")

func _on_player_player_climbed_high(action_position, flip_h):
	var instance = CLIMB_HIGH.instantiate()
	add_child(instance)
	instance.position = action_position
	instance.flip_h = flip_h
	if (flip_h):
		instance.offset.x *= -1
	instance.fade_and_kill()

func _on_player_player_climbed_low(action_position, flip_h):
	var instance = CLIMB_LOW.instantiate()
	add_child(instance)
	instance.position = action_position
	instance.flip_h = flip_h
	if (flip_h):
		instance.offset.x *= -1
	instance.fade_and_kill()


func _on_player_player_attacked(action_position, flip_h):
	var instance = ATTACK.instantiate()
	add_child(instance)
	instance.position = action_position
	instance.flip_h = flip_h
	if (flip_h):
		instance.offset.x *= -1
	instance.fade_and_kill()
