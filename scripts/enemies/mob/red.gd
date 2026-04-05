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
var move_speed: float = 7.0
var max_hp: float = 100.0
var current_hp: float = 100.0
var attack_range: float = 2.0
var attack_damage: float = 10.0
var can_attack: bool = true

func _physics_process(delta: float) -> void:
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

func _on_aggro_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		current_state = State.CHASE
