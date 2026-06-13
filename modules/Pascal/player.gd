extends CharacterBody2D


const SPEED = 30000.0
@onready var rays: Node2D = $Rays


func _physics_process(delta: float) -> void:
	
	#var move_vec = Input.get_vector("left", "right", "up", "down")
#
	#velocity = move_vec * delta * SPEED

	move_and_slide()
