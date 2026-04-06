extends Area3D

# --- Repulse Projectile Config ---
var speed: float
var damage: float
var force: float
var max_range: float
var direction: Vector3
var distance_traveled: float = 0.0

func setup(dir: Vector3, spd: float, dmg: float, rge: float, frc: float):
	direction = dir
	speed = spd
	damage = dmg
	max_range = rge
	force = frc

func _physics_process(delta: float) -> void:
	var movement = direction * speed * delta
	global_position += movement
	distance_traveled += movement.length()
	if distance_traveled >= max_range:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	print("entered ", body)
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("apply_knockback"):
			body.apply_knockback(direction, force)
		queue_free()
