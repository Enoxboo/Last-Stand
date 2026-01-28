class_name ProjectileUtils

const PROJECTILE = preload("uid://bl67w6kqa0ywr")

static func throw_projectile(soldier: Soldier, target: Monster, speed: float, damage: int):
	var proj = PROJECTILE.instantiate()
	proj.direction = (target.global_position - soldier.global_position).normalized()
	proj.speed = speed
	proj.damage = damage
	proj.look_at(proj.position + proj.direction)
	
	soldier.get_parent().call_deferred("add_child", proj)
