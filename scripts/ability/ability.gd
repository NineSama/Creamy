extends RefCounted
class_name ability

var cooldown: float = 0.1
var cooldown_timer: float = 0.0

func update(delta: float):
	if cooldown_timer >= 0.0:
		cooldown_timer -= delta

func can_cast() -> bool:
	return cooldown_timer <= 0.0

func trigger_cooldown():
	cooldown_timer = cooldown

func cast(_player):
	pass
