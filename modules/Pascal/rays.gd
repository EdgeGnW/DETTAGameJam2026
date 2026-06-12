extends Node2D

var rays: Array[Line2D]

@export var low_intensity = 10
@export var high_intensity = 30
@export var highlighted_intensity = 600

var current_highlight: int

func _ready() -> void:
	rays.assign(find_children("*", "Line2D", false, false))
	
func highlight_ray(index: int):
	pass
	
	
