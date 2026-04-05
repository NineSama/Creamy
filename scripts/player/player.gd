extends CharacterBody3D

@onready var gravity: float = -9.8

# --- Player config ---
var move_speed: float = 8.0
var max_hp: float = 100.0
var current_hp: float = 100.0

# --- Dash System ---
var dash: playerDash
var last_direction: Vector3 = Vector3.FORWARD

# --- Ability System ---
var aether_shard: AetherShard
var repulse: Repulse

func _ready() -> void:
	dash = playerDash.new(self)
	aether_shard = AetherShard.new()
	repulse = Repulse.new()

func _physics_process(delta: float) -> void:
	aether_shard.update(delta)
	repulse.update(delta)
	if dash.is_dashing:
		dash.handle_dash(delta)
	else:
		handle_movement(delta)
	move_and_slide()

func handle_movement(delta: float):
	var direction = get_input_direction()
	
	if direction:
		last_direction = direction
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = 0
		velocity.z = 0
	if not is_on_floor():
		velocity.y += gravity * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		dash.start_dash(last_direction)
	if event.is_action_pressed("aether_shard"):
		aether_shard.cast(self)
	if event.is_action_pressed("repulse"):
		repulse.cast(self)

func get_input_direction() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(input_dir.x, 0, input_dir.y)

func get_aim_direction() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0
	
	var plane = Plane(Vector3.UP, global_position.y)
	var hit_position = plane.intersects_ray(from, to)
	
	if not hit_position:
		return last_direction
	var direction = (hit_position - global_position).normalized()
	return direction
