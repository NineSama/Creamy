extends ability
class_name Repulse

var projectile_scene = preload("res://scenes/ability/light/RepulseProjectile.tscn")

var damage: float = 15.0
var speed: float = 25.0
var max_range: float = 18.0
var force: float = 2.0

func cast(player):
	if not can_cast():
		return
	
	var projectile = projectile_scene.instantiate()
	player.get_parent().add_child(projectile)
	
	projectile.global_position = player.global_position + Vector3.UP * 1.0
	projectile.setup(player.get_aim_direction(), speed, damage, max_range, force)
	
	trigger_cooldown()
