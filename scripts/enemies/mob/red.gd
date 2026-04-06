extends CharacterBody3D

enum State {
	IDLE,
	CHASE
}

# --- Config ---
@export var gravity: float = -9.8
var current_state = State.IDLE
var player: Node3D

# --- Red Config ---
@onready var mesh: MeshInstance3D = $MeshInstance3D
var color: Color = Color8(94, 162, 124)
var move_speed: float = 7.0
var max_hp: float = 200.0
var current_hp: float = 200.0
var attack_range: float = 4.0
var attack_damage: float = 10.0
var can_attack: bool = true
var is_knocked: bool = false
var knockback_speed: float = 20.0
var knockback_force: float = 0.0
var knockback_dir: Vector3 = Vector3.ZERO

func _ready():
	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()
	mesh.material_override.albedo_color = color

func _physics_process(delta: float) -> void:
	if is_knocked:
		handle_knockback(delta)
	else:
		match current_state:
			State.IDLE:
				velocity = Vector3.ZERO
			State.CHASE:
				chase_player(delta)
	move_and_slide()

func chase_player(delta: float):
	if not player:
		return
	
	var direction = player.global_transform.origin - global_transform.origin
	var distance = direction.length()
	
	if distance > attack_range:
		direction = direction.normalized()
		velocity = direction * move_speed
	else:
		velocity = Vector3.ZERO
		attack_player()
	# Gravity on spawn
	if not is_on_floor():
		velocity.y += delta * gravity

func attack_player():
	if not can_attack or not player:
		return
	if player.has_method("take_damage"):
		player.take_damage(attack_damage)
	
	# Attack Cooldown
	can_attack = false
	$attack_cd.start()
	await $attack_cd.timeout
	can_attack = true

func take_damage(amount: float):
	current_hp -= amount
	hit_indicator()
	print("Enemy : ", current_hp)
	if current_hp <= 0.0:
		print("Enemy died!")
		queue_free()

func hit_indicator():
	mesh.material_override.albedo_color = Color(0.504, 0.161, 0.077, 1.0)
	await get_tree().create_timer(0.1).timeout
	mesh.material_override.albedo_color = color

func apply_knockback(dir: Vector3, force: float):
	print("hello")
	is_knocked = true
	knockback_dir = dir.normalized()
	knockback_force = force

func handle_knockback(delta: float):
	var step = knockback_speed * delta
	
	if step > knockback_force:
		step = knockback_force
	velocity = knockback_dir * knockback_speed
	knockback_force -= step
	if knockback_force <= 0:
		is_knocked = false
		velocity = Vector3.ZERO

func _on_aggro_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		current_state = State.CHASE
