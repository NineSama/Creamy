extends Area3D

# --- Void Slash Area Config ---
var damage: float
var force: float
var angle_cone: float = 45.0
var direction: Vector3

func setup(dir: Vector3, dmg: float, frc: float):
	direction = dir.normalized()
	damage = dmg
	force = frc
	
	print("yo")
	if direction:
		look_at(global_position + direction, Vector3.UP)
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		print(body)
		var dir_to_enemy = (body.global_position - global_position).normalized()
		var angle = rad_to_deg(direction.angle_to(dir_to_enemy))
		
		if angle <= angle_cone:
			if body.has_method("take_damage"):
				body.take_damage(damage)
			if body.has_method("apply_knockback"):
				body.apply_knockback(direction, force)
