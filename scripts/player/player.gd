extends CharacterBody3D

@onready var gravity: float = -9.8

# --- Player config ---
var move_speed: float = 20.0

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	move_and_slide()

func handle_movement(delta: float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y)

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = 0
		velocity.z = 0
	if not is_on_floor():
		velocity.y += gravity * delta
