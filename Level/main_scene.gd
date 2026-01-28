extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer

const MONSTER = preload("uid://bs5im87ttvyd4")
const MONSTER_DATA: Dictionary = {
	"ROUNDED" : preload("uid://d6mpo3abrayd"),
	"RUSHER" : preload("uid://f47usr5iwmlb"),
	"TANK" : preload("uid://6ve0nx0tm8b4")
}

@export var soldier: Soldier

var monster_types: Array = ["ROUNDED", "RUSHER", "TANK"]
var current_index: int = 0
var can_spawn = true

var selected_monster: MonsterData:
	get:
		return MONSTER_DATA[monster_types[current_index]]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_monster") and can_spawn:
		spawn_monster()
	
	if event.is_action_pressed("move_right"):
		current_index = (current_index + 1) % monster_types.size()
		print("Monstre sélectionné: ", monster_types[current_index])
	
	if event.is_action_pressed("move_left"):
		current_index = (current_index - 1 + monster_types.size()) % monster_types.size()
		print("Monstre sélectionné: ", monster_types[current_index])

func spawn_monster():
	spawn_timer.start()
	can_spawn = false
	var monster = MONSTER.instantiate()
	
	monster.soldier = soldier
	monster.global_position = get_global_mouse_position()
	monster.data = selected_monster
	
	add_child(monster)


func _on_spawn_timer_timeout() -> void:
	can_spawn = true
