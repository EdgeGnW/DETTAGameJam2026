class_name Player
extends CharacterBody2D


const SPEED = 1000.0

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var rays: Node2D = %Rays
@export var texture: Texture2D:
	set(value):
		sprite_2d.texture = texture


func _physics_process(delta: float) -> void:
	
	#var move_vec = Input.get_vector("left", "right", "up", "down")
#
	#velocity = move_vec * SPEED

	move_and_slide()

func move(direction: Vector2):
	velocity = direction * SPEED
