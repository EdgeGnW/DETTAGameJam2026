extends Node2D

var rays: Array[Line2D]

@export var low_intensity = 0.05
@export var high_intensity = 0.1
@export var highlighted_intensity = 0.3

var current_highlight: int = 0

func _ready() -> void:
	rays.assign(find_children("*", "Line2D", false, false))
	print(len(rays))
	
func highlight_ray(index: int) -> void:
	if index == current_highlight:
		return
	rays[current_highlight].gradient.set_color(0, Color(1, 1, 1, high_intensity))
	current_highlight = index
	rays[current_highlight].gradient.set_color(0, Color(1, 1, 1, highlighted_intensity))
	
	
