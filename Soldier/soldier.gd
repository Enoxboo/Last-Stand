extends Area2D

class_name Soldier

@onready var detection_area: Area2D = $DetectionArea
var projectile_speed: float = 1000
var projectile_damage: int = 1
var max_hp: int = 5
var current_hp: int


func _ready() -> void:
	current_hp = max_hp


func _draw():
	draw_arc(Vector2.ZERO, 200, 0, TAU, 64, Color(0.749, 0.886, 0.498, 1.0), 5)


func _process(_delta: float) -> void:
	if detection_area.get_overlapping_areas():
		print(detection_area.get_overlapping_areas())


func _on_attack_reload_timeout() -> void:
	var monsters_in_range = detection_area.get_overlapping_bodies()
	
	if not monsters_in_range:
		return
		
	var closest_monster: Monster
	var closest_distance: float = 200.0
	
	for monster in monsters_in_range:
		var distance = monster.global_position.distance_to(global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_monster = monster
	
	if not closest_monster:
		return
	
	ProjectileUtils.throw_projectile(self, closest_monster, projectile_speed, projectile_damage)


func take_damage(damage) -> void:
	current_hp -= damage
	
	if current_hp <= 0:
		print("game over")
