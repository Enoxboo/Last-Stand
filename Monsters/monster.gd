extends CharacterBody2D
class_name Monster

@onready var sprite_2d: Sprite2D = $Sprite2D

var data: MonsterData
var soldier: Soldier
var current_hp: int
var direction: Vector2
var is_retreating = false
var speed: float

func _ready() -> void:
	speed = data.speed
	current_hp = data.hp_max
	sprite_2d.texture = data.sprite


func _process(_delta: float) -> void:
	if not is_retreating:
		direction = (soldier.global_position - global_position).normalized()
	
	velocity = speed * direction
	move_and_slide()


func take_damage(damage: int) -> void:
	current_hp -= damage
	
	if current_hp <= 0:
		queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(data.damage)
	retreat_on_hit()

func retreat_on_hit() -> void:
	is_retreating = true
	var retreat_time: float = 0.5
	var initial_speed: float = data.speed
	var retreat_speed: float = 10
	speed = retreat_speed
	direction = - direction
	
	await get_tree().create_timer(retreat_time).timeout
	
	data.speed = initial_speed
	direction = - direction
	is_retreating = false
