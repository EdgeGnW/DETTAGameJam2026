extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2

func _physics_process(_delta: float) -> void:
	
	if position.y > 0:
		get_tree().reload_current_scene()
	
	velocity += get_gravity() * 0.8
	velocity.y = clamp(velocity.y, -500, 500)
	
	move_and_slide()
	
	var body: Player2D
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() is Player2D:
		body = ray_cast_2d.get_collider()
	elif ray_cast_2d_2.is_colliding() and ray_cast_2d_2.get_collider() is Player2D:
		body = ray_cast_2d_2.get_collider()
	else:
		print("nein")
		return
	print("ja")
	
	body.lure(global_position)
	
	
