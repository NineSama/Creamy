extends RefCounted
class_name swapForm

enum Form {
	LIGHT,
	DARK
}

# --- Player ---
var current_form: Form = Form.LIGHT

# --- Light Form ---
# --- Dark Form ---

func swap_form(player):
	if current_form == Form.LIGHT:
		current_form = Form.DARK
	else:
		current_form = Form.LIGHT
	apply_color(player)

func apply_color(player: CharacterBody3D) -> void:
	if current_form == Form.LIGHT:
		player.mesh.material_override.albedo_color = Color(0.382, 0.49, 0.535, 1.0)
	else:
		player.mesh.material_override.albedo_color = Color(0.15, 0.15, 0.2, 1.0)

# getters
func is_light() -> bool:
	return current_form == Form.LIGHT
func is_dark() -> bool:
	return current_form == Form.DARK
