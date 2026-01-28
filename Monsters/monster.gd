extends CharacterBody2D
class_name Monster

@onready var sprite_2d: Sprite2D = $Sprite2D

var data: MonsterData
var soldier: Soldier
var current_hp: int


func _ready() -> void:
	current_hp = data.hp_max
	sprite_2d.texture = data.sprite


func _process(delta: float) -> void:
	var direction = (soldier.global_position - global_position).normalized()
	velocity += data.speed * direction * delta
	move_and_slide()


func take_damage(damage: int) -> void:
	current_hp -= damage
	
	if current_hp <= 0:
		queue_free()
