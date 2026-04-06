extends CharacterBody3D
class_name Player

@onready var gravity: float = -9.8

# --- Player config ---
@onready var mesh: MeshInstance3D = $MeshInstance3D
var color: Color = Color(0.382, 0.49, 0.535, 1.0)
var move_speed: float = 20.0
var max_hp: float = 1000.0
var current_hp: float = 1000.0

# --- Form System ---
var form: swapForm

# --- Dash System ---
var dash: playerDash
var last_direction: Vector3 = Vector3.FORWARD

# --- GCD System ---
var gcd: GCD

# --- Ability System ---
var aether_shard: AetherShard
var repulse: Repulse
var void_slash: VoidSlash

# --- UI System ---
signal hp_changed(current: float, max: float)

func _ready() -> void:
	add_to_group("player")
	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()
	form = swapForm.new()
	form.apply_color(self)
	dash = playerDash.new(self)
	gcd = GCD.new()
	# Abilities
	aether_shard = AetherShard.new()
	repulse = Repulse.new()
	void_slash = VoidSlash.new()
	emit_signal("hp_changed", current_hp, max_hp)

func _physics_process(delta: float) -> void:
	aether_shard.update(delta)
	repulse.update(delta)
	void_slash.update(delta)
	gcd.update(delta)
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
	if event.is_action_pressed("swap"):
		form.swap_form(self)
	# LIGHT ABILITIES
	if event.is_action_pressed("basic") and form.is_light():
		aether_shard.cast(self)
	if event.is_action_pressed("repulse") and form.is_light():
		repulse.cast(self)
	# DARK ABILITIES
	if event.is_action_pressed("basic") and form.is_dark():
		void_slash.cast(self)

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

func take_damage(amount: float):
	current_hp -= amount
	hit_indicator()
	print("Player : ", current_hp)
	emit_signal("hp_changed", current_hp, max_hp)
	if current_hp <= 0.0:
		print("You died!")
		queue_free()

func hit_indicator():
	mesh.material_override.albedo_color = Color(0.504, 0.161, 0.077, 1.0)
	await get_tree().create_timer(0.1).timeout
	form.apply_color(self)
