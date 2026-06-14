class_name Player
extends Area2D

@onready var rays: Rays = %Rays
@export var color: Vector3i
var tween: Tween
var sceneToEnter: PackedScene

var grid_position: Vector2i

func skip_tween():
	if tween and tween.is_valid() and tween.is_running():
		tween.pause()
		tween.custom_step(9999999)
		tween.kill()
