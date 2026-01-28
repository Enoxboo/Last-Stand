extends Area2D

class_name Soldier

@onready var detection_area: Area2D = $DetectionArea
var projectile_speed: float = 1000
var projectile_damage: int = 1


func _process(delta: float) -> void:
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
	
	ProjectileUtils.throw_projectile(self, closest_monster, projectile_speed, projectile_damage)
