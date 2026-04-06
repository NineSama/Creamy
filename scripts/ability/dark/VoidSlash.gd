extends ability
class_name VoidSlash

var slash_scene = preload("res://scenes/ability/dark/VoidSlashArea.tscn")

var damage: float = 30.0
var slash_range: float = 10.0
var angle: float = 50.0
var force: float = 3.0

func cast(player):
	print("hello")
	if not can_cast():
		return
	if player.gcd.is_on_gcd():
		return
		
	var slash = slash_scene.instantiate()
	player.get_parent().add_child(slash)
	
	# Position depending on the player
	slash.global_position = player.global_position
	slash.setup(player.get_aim_direction(), damage, force)
	
	trigger_cooldown()
	player.gcd.trigger_gcd()
