extends Control

@export var max_value: float = 100.0
var current_value: float = 100.0

@onready var fill_bar = $Background/FillBar
@onready var dmg_bar = $Background/DamageBar
@onready var label = $Label

var target_ratio: float = 1.0
var displayed_ratio: float = 1.0
@export var dmg_lerp_speed: float = 3.0

func _ready():
	update_visual()

func _process(delta: float) -> void:
	displayed_ratio = lerp(displayed_ratio, target_ratio, delta * dmg_lerp_speed)
	dmg_bar.scale.x = displayed_ratio

func set_value(current: float, maxhp: float):
	max_value = maxhp
	current_value = current
	
	target_ratio = float(current_value) / max_value
	label.text = str(current_value) + " / " + str(max_value)
	update_visual()

func update_visual():
	target_ratio = float(current_value) / max_value
	fill_bar.scale.x = target_ratio
	label.text = str(current_value) + " / " + str(max_value)
