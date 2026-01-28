extends Area2D

class_name Projectile

var direction: Vector2
var speed: float
var damage: int


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_fade_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(damage)
