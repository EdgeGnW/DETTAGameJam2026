class_name Player
extends Area2D

@onready var rays: Rays = %Rays
@export var color: Vector3i
const TRAIL:= preload("uid://cac8gpndpiw2y")
var trail
@onready var sprite: AnimatedSprite2D = $Uriel

var alpha := 1.0

var ryb2rgb := {
	Vector3i(0, 0, 1): Color(0,0,1),
	Vector3i(0, 1, 0): Color(1,1,0),
	Vector3i(0, 1, 1): Color(0,1,0),
	Vector3i(1, 0, 0): Color(1,0,0),
	Vector3i(1, 0, 1): Color(0.75,0,1),
	Vector3i(1, 1, 0): Color(1,0.5,0),
	Vector3i(1, 1, 1): Color(1,1,1),
}



var tween: Tween
var sceneToEnter: PackedScene

var grid_position: Vector2i

func clean_effects():
	trail.reset_trail()
	trail.hide()
	
func show_effects():
	trail.show()

func _ready():
	for child in get_children():
		if child is Sprite2D and child != sprite:
			child.queue_free.call_deferred()
	trail = TRAIL.instantiate()
	trail.node2d = self
	get_parent().add_child.call_deferred(trail)
	alpha = 1.0
	var c = ryb2rgb[color]
	if color != Vector3i(1,1,1):
		alpha = 0.7
	
	sprite.modulate = Color(c.r, c.g, c.b, 0)
	
	fade_in()
	clean_effects()

func skip_tween():
	if tween and tween.is_valid() and tween.is_running():
		tween.pause()
		tween.custom_step(9999999)
		tween.kill()
		
	
func fade_in():
	sprite.modulate.a = 0
	var alpha_tween = create_tween()
	alpha_tween.tween_property(sprite, "modulate:a", alpha, 0.5)
	return alpha_tween
	
func fade_out():
	sprite.modulate.a = alpha
	var alpha_tween = create_tween()
	alpha_tween.tween_property(sprite, "modulate:a", 0, 0.5)
	return alpha_tween

	
		
