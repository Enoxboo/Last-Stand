extends Node2D

const MONSTER = preload("uid://bs5im87ttvyd4")

var soldier: Soldier
var data: MonsterData

func _on_timer_timeout() -> void:
	var monster = MONSTER.instantiate()
	
	monster.soldier = soldier
	monster.global_position = global_position
	monster.data = data
	
	get_parent().add_child(monster)

	queue_free()
