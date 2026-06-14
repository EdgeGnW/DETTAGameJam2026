class_name Player
extends Area2D

@onready var rays: Rays = %Rays
@export var color: Vector3i
const TRAIL:= preload("uid://cac8gpndpiw2y")
var trail


var tween: Tween
var sceneToEnter: PackedScene

var grid_position: Vector2i

func clean_effects():
	trail.reset_trail()

func _ready():
	trail = TRAIL.instantiate()
	trail.node2d = self
	get_parent().add_child.call_deferred(trail)

func skip_tween():
	if tween and tween.is_valid() and tween.is_running():
		tween.pause()
		tween.custom_step(9999999)
		tween.kill()
		
