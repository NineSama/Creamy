extends RefCounted
class_name playerDash

# --- Dash Config ---
var dash_direction: Vector3 = Vector3.FORWARD
var dash_speed: float = 50.0
var dash_timer: float = 0.0
var dash_duration: float = 0.2
var is_dashing: bool = false

# --- Player Reference ---
var player: CharacterBody3D = null

func _init(p: CharacterBody3D) -> void:
	player = p

func start_dash(direction: Vector3) -> void:
	if is_dashing:
		return
	dash_direction = direction.normalized()
	dash_timer = dash_duration
	is_dashing = true

func handle_dash(delta: float):
	player.velocity.x = dash_direction.x * dash_speed
	player.velocity.z = dash_direction.z * dash_speed
	
	dash_timer -= delta
	if dash_timer <= 0:
		is_dashing = false
