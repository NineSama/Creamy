extends CharacterBody3D

@onready var gravity: float = -9.8

# --- Player config ---
var move_speed: float = 8.0
var max_hp: float = 100.0
var current_hp: float = 100.0

# --- Dash System ---
var dash: playerDash
var last_direction: Vector3 = Vector3.FORWARD

func _ready() -> void:
	dash = playerDash.new(self)

func _physics_process(delta: float) -> void:
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

func get_input_direction() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(input_dir.x, 0, input_dir.y)
