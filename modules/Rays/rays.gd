class_name Rays
extends Node2D

var rays: Array[Line2D]

@export var normal_intensity := 30
@export var normal_width := 10
@export var normal_length := 400
@export var highlight_intensity := 60
@export var highlight_width := 20
@export var highlight_length := 800
@export var selected_intensity := 180
@export var selected_width := 40
@export var selected_length := 900
@export var tween_time := 0.2

var highlight_index: int = 0
var has_highlight := false
var selected_index: int = -1
var has_selection := false

var active = false

var tween: Tween

func _ready() -> void:
	rays.assign(find_children("*", "Line2D", false, false))
	for ray in rays:
		ray.gradient = Gradient.new()
		ray.gradient.colors[0] = Color.WHITE
		ray.gradient.colors[0].a = normal_intensity / 255.0
		ray.gradient.colors[1] = Color.WHITE
		ray.gradient.colors[1].a = normal_intensity / 255.0
	deactivate()
	
func reset():
	has_selection = false
	has_highlight = false
	selected_index = -1
	highlight_index = -1
	for i in range(len(rays)):
		rays[i].gradient.colors[0].a = 0
		rays[i].gradient.colors[1].a = 0
	
func deactivate():
	for i in range(len(rays)):
		if i == selected_index and has_selection: continue
		rays[i].gradient.colors[0].a = 0
		rays[i].gradient.colors[1].a = 0
	active = false
	has_highlight = false
	
func activate():
	for i in range(len(rays)):
		var ray = rays[i]
		if i == selected_index and has_selection: continue
		ray.points[1].x = normal_length
		ray.width = normal_width
		ray.gradient.colors[0].a = normal_intensity / 255.0
		ray.gradient.colors[1].a = normal_intensity / 255.0
	active = true
	
	
	
func highlight_ray(index: int) -> void:
	if not active: return

	if index == highlight_index and has_highlight:
		return
	
	if tween and tween.is_valid() and tween.is_running():
		tween.pause()
		tween.custom_step(tween_time)
		tween.kill()
		
	tween = create_tween()
	tween.set_parallel()
	#stop if theres nothing to tween
	var kill_tween = true
	#reset old ray
	if has_highlight and (highlight_index != selected_index or not has_selection):
		var old_line = rays[highlight_index]
		kill_tween = false
		tween.tween_property(old_line, "width", normal_width, tween_time)
		tween.tween_method(tween_length.bind(old_line),
			highlight_length,
			normal_length,
			tween_time)
		tween.tween_method(tween_intensity.bind(old_line),
			highlight_intensity,
			normal_intensity,
			tween_time)
	
	#set new ray
	highlight_index = index
	if highlight_index == selected_index and has_selection:
		has_highlight = false
		if kill_tween: tween.kill()
		return
	
	kill_tween = false
	has_highlight = true
	var new_line = rays[highlight_index]
	tween.tween_property(new_line, "width", highlight_width, tween_time)
	tween.tween_method(tween_length.bind(new_line),
		normal_length,
		highlight_length,
		tween_time)
	tween.tween_method(tween_intensity.bind(new_line),
		normal_intensity,
		highlight_intensity,
		tween_time)
	if kill_tween: tween.kill()
		
func select_ray() -> void:
	
	if not active or not has_highlight or highlight_index == selected_index:
		return
	
	var old_line = rays[selected_index]
	
	selected_index = highlight_index
	
	var new_line = rays[selected_index]

	if tween:
		tween.pause()
		tween.custom_step(tween_time)
		tween.kill()
		
	tween = create_tween()
	tween.set_parallel()
	
	#reset old ray
	if has_selection:
		tween.tween_property(old_line, "width", normal_width, tween_time)
		tween.tween_method(tween_length.bind(old_line),
			selected_length,
			normal_length,
			tween_time)
		tween.tween_method(tween_intensity.bind(old_line),
			selected_intensity,
			normal_intensity,
			tween_time)
	
	has_selection = true
	
	#set new ray
	tween.tween_property(new_line, "width", selected_width, tween_time)
	tween.tween_method(tween_length.bind(new_line),
		highlight_length,
		selected_length,
		tween_time)
	tween.tween_method(tween_intensity.bind(new_line),
		highlight_intensity,
		selected_intensity,
		tween_time)
		
		
func tween_length(length: int, ray: Line2D) -> void:
	ray.points[1].x = length
		
func tween_intensity(intensity: float, ray: Line2D) -> void:
	ray.gradient.colors[0].a = intensity/255.0
		
	
