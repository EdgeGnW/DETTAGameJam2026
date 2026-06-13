class_name Player
extends Area2D

@onready var rays: Rays = %Rays
var tween: Tween

var grid_position: Vector2i

func skip_tween():
	tween.pause()
	tween.custom_step(9999999)
	tween.kill()
