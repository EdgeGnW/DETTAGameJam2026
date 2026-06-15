class_name Rays
extends Node2D

var rays: Array[Line2D]

class rayProperies:
	var intensity: int
	var width: int
	var length: int
	
	func _init(i, w, l) -> void:
		intensity = i
		width = w
		length = l

var normal_ray := rayProperies.new(30, 10, 400)
var highlighted_ray := rayProperies.new(60, 20, 800)
var selected_ray := rayProperies.new(180, 40, 900)

var tween_time := 0.2



var highlight_index: int = -1
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
		ray.gradient.colors[0].a = normal_ray.intensity / 255.0
		ray.gradient.colors[1] = Color.WHITE
		ray.gradient.colors[1].a = normal_ray.intensity / 255.0
	deactivate()
	
func clear_selection():
	has_selection = false
	
func reset():
	skip_tween()
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
		ray.points[1].x = normal_ray.length
		ray.width = normal_ray.width
		ray.gradient.colors[0].a = normal_ray.intensity / 255.0
		ray.gradient.colors[1].a = normal_ray.intensity / 255.0
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
		tween_ray(old_line, highlighted_ray, normal_ray)
	
	#set new ray
	highlight_index = index
	if highlight_index == selected_index and has_selection:
		has_highlight = false
		if kill_tween: tween.kill()
		return
	
	kill_tween = false
	has_highlight = true
	var new_line = rays[highlight_index]
	tween_ray(new_line, normal_ray, highlighted_ray)
	if kill_tween: tween.kill()
		
func select_ray() -> void:
	
	if not active or not has_highlight or highlight_index == selected_index:
		return
	
	var old_line = rays[selected_index]
	
	selected_index = highlight_index
	
	var new_line = rays[selected_index]

	skip_tween()
		
	tween = create_tween()
	tween.set_parallel()
	
	#reset old ray
	if has_selection:
		tween_ray(old_line, selected_ray, normal_ray)
	
	has_selection = true
	
	#set new ray
	tween_ray(new_line, highlighted_ray, selected_ray)
		
		
func tween_length(length: int, ray: Line2D) -> void:
	ray.points[1].x = length
		
func tween_intensity(intensity: float, ray: Line2D) -> void:
	ray.gradient.colors[0].a = intensity/255.0
		
func tween_ray(ray: Line2D, from_properties: rayProperies, to_properties: rayProperies):
	tween.tween_property(ray, "width", to_properties.width, tween_time)
	tween.tween_method(tween_length.bind(ray),
		from_properties.length,
		to_properties.length,
		tween_time)
	tween.tween_method(tween_intensity.bind(ray),
		from_properties.intensity,
		to_properties.intensity,
		tween_time)
	
func skip_tween():
	if tween:
		tween.pause()
		tween.custom_step(999999)
		tween.kill()
