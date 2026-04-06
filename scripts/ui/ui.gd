extends CanvasLayer

@onready var hp_bar = $Control/Healthbar

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	player.hp_changed.connect(_on_player_hp_changed)

func _on_player_hp_changed(current, maxhp):
	hp_bar.set_value(current, maxhp)
