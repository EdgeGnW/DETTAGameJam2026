class_name Player
extends Area2D

@onready var rays: Rays = %Rays
@export var color: Vector3i
const TRAIL:= preload("uid://cac8gpndpiw2y")
var trail

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var ryb2rgb := {
	Vector3i(0, 0, 1): Color(0,0,1),
	Vector3i(0, 1, 0): Color(1,1,0),
	Vector3i(0, 1, 1): Color(0,1,0),
	Vector3i(1, 0, 0): Color(1,0,0),
	Vector3i(1, 0, 1): Color(0.5,0,1),
	Vector3i(1, 1, 0): Color(1,0.5,0),
	Vector3i(1, 1, 1): Color(1,1,1),
}



var tween: Tween
var sceneToEnter: PackedScene

var grid_position: Vector2i

func clean_effects():
	trail.reset_trail()

func _ready():
	trail = TRAIL.instantiate()
	trail.node2d = self
	get_parent().add_child.call_deferred(trail)
	var a = 1.0
	var c = ryb2rgb[color]
	if color != Vector3i(1,1,1):
		a = 0.7
	
	sprite.modulate = Color(c.r, c.g, c.b, a)

func skip_tween():
	if tween and tween.is_valid() and tween.is_running():
		tween.pause()
		tween.custom_step(9999999)
		tween.kill()
		
func _process(delta: float) -> void:
	sprite.position.y = sin(Engine.get_frames_drawn() / 10)
	
		
