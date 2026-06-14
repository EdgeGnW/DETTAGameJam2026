class_name Rays
extends Node2D

var rays: Array[Line2D]

@export var low_intensity := 10
@export var low_width := 5
@export var low_length := 250
@export var high_intensity := 19
@export var high_width := 10
@export var high_length := 500
@export var highlighted_intensity := 60
@export var highlighted_width := 20
@export var highlighted_length := 750
@export var tween_time := 0.2

var current_highlight: int = 0

var active = false

var tween: Tween

func _ready() -> void:
	rays.assign(find_children("*", "Line2D", false, false))
	for ray in rays:
		ray.gradient = Gradient.new()
		ray.gradient.colors[0] = Color.WHITE
		ray.gradient.colors[0].a = high_intensity / 255
		ray.gradient.colors[1] = Color.WHITE
		ray.gradient.colors[1].a = low_intensity / 255
	deactivate()
	
func deactivate():
	for i in range(len(rays)):
		if i == current_highlight: continue
		rays[i].points[1].x = low_length
		rays[i].width = low_width
		rays[i].gradient.colors[0].a = low_intensity/255
	active = false
		
func activate():
	for ray in rays:
		ray.points[1].x = high_length
		ray.width = high_width
		ray.gradient.colors[0].a = high_intensity/255
	active = true
	
	
func highlight_ray(index: int) -> void:
	if not active: return

	if index == current_highlight:
		return
	var tween_length = func(length: int, ray: Line2D) -> void:
		ray.points[1].x = length
		
	var tween_intensity = func(intensity: float, ray: Line2D) -> void:
		ray.gradient.colors[0].a = intensity/255

	if tween:
		tween.pause()
		tween.custom_step(tween_time)
		tween.kill()
		
	tween = create_tween()
	tween.set_parallel()
	
	#reset old ray
	var old_line = rays[current_highlight]
	tween.tween_property(old_line, "width", high_width, tween_time)
	tween.tween_method(tween_length.bind(old_line),
		highlighted_length,
		high_length,
		tween_time)
	tween.tween_method(tween_intensity.bind(old_line),
		highlighted_intensity,
		high_intensity,
		tween_time)
	
	#set new ray
	current_highlight = index
	var new_line = rays[current_highlight]
	tween.tween_property(new_line, "width", highlighted_width, tween_time)
	tween.tween_method(tween_length.bind(new_line),
		high_length,
		highlighted_length,
		tween_time)
	tween.tween_method(tween_intensity.bind(new_line),
		high_intensity,
		highlighted_intensity,
		tween_time)
		
	
