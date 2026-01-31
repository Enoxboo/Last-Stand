extends Node2D

signal spawned_too_close
signal spawn_on_cooldown

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ui: CanvasLayer = $UI

const WIN_SCREEN = preload("uid://dkuuc5rdica8f")
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
var is_spawn_allowed = false

var selected_monster: MonsterData:
	get:
		return MONSTER_DATA[monster_types[current_index]]

func _ready():
	ui.spawn_timer = spawn_timer
	ui.update_monster_icon(monster_types[current_index])
	soldier.is_dead.connect(_on_soldier_death)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_monster"):
		if not can_spawn:
			spawn_on_cooldown.emit()
		elif not is_spawn_allowed:
			spawned_too_close.emit()
		else:
			spawn_monster()
	
	if event.is_action_pressed("move_right"):
		current_index = (current_index + 1) % monster_types.size()
		print("Monstre sélectionné: ", monster_types[current_index])
		ui.update_monster_icon(monster_types[current_index])
	
	if event.is_action_pressed("move_left"):
		current_index = (current_index - 1 + monster_types.size()) % monster_types.size()
		print("Monstre sélectionné: ", monster_types[current_index])
		ui.update_monster_icon(monster_types[current_index])

func spawn_monster():
	spawn_timer.start()
	can_spawn = false
	ui.start_cooldown()
	
	var monster = MONSTER.instantiate()
	
	monster.soldier = soldier
	monster.global_position = get_global_mouse_position()
	monster.data = selected_monster
	
	add_child(monster)

func _on_spawn_timer_timeout() -> void:
	can_spawn = true

func _on_spawn_limit_mouse_entered() -> void:
	is_spawn_allowed = false

func _on_spawn_limit_mouse_exited() -> void:
	is_spawn_allowed = true

func _on_soldier_death() -> void:
	get_tree().call_deferred("change_scene_to_packed", WIN_SCREEN)
