extends ability
class_name AetherShard

var projectile_scene = preload("res://scenes/ability/light/AetherShardProjectile.tscn")

var damage: float = 10.0
var speed: float = 30.0
var max_range: float = 25.0

func cast(player):
	if not can_cast():
		return
	
	if player.gcd.is_on_gcd():
		return
	
	var projectile = projectile_scene.instantiate()
	player.get_parent().add_child(projectile)
	
	projectile.global_position = player.global_position + Vector3.UP * 1.0
	projectile.setup(player.get_aim_direction(), speed, damage, max_range)
	
	trigger_cooldown()
	player.gcd.trigger_gcd()
