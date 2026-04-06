extends RefCounted
class_name GCD

# --- Global Cooldown Config ---
var gcd_duration: float = 0.5
var gcd_timer: float = 0.0

func update(delta: float):
	if gcd_timer > 0.0:
		gcd_timer -= delta

func is_on_gcd() -> bool:
	return gcd_timer > 0.0

# Start GCD
func trigger_gcd():
	gcd_timer = gcd_duration
