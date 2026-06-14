class_name Player
extends Area2D

@onready var rays: Rays = %Rays
@export var color: Vector3i
@onready var particles: GPUParticles2D = $GPUParticles2D


var tween: Tween
var sceneToEnter: PackedScene

var grid_position: Vector2i

func show_effects():
	particles.emitting = true
	
func hide_effects():
	particles.emitting = false

func skip_tween():
	if tween and tween.is_valid() and tween.is_running():
		tween.pause()
		tween.custom_step(9999999)
		tween.kill()
