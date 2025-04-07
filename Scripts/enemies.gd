extends Node

signal player_died
signal enemy_died

func _on_player_died():
	player_died.emit()


func _on_enemy_died():
	enemy_died.emit()

func _on_ready():
	for child in get_children(true):
		child.connect("player_died", _on_player_died)
		child.connect("enemy_died", _on_enemy_died)
