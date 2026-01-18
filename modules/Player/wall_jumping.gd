extends PlayerMovementState

var rotation: int
var normal: Vector2

func physics_update(_delta):
	if not subject.animal_state == AnimalState.Animal_state.ACTIVE:
		transition.emit("Idle")
	if not subject.is_on_floor():
		if subject.is_on_wall():
			transition.emit("WallSliding")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
	else:
		transition.emit("Idle")
		
#func update(delta):
#	subject.sprite_2d.rotate(delta * 10 * rotation)

func enter():
	subject.sprite_2d.play("jump")
	normal = subject.get_wall_normal()
	subject.velocity.x = sign(normal.x) * subject.speed
	subject.jump()
	subject.wall_jumped = sign(normal.x)
	subject.flip_character()
	$Timer.start()
	rotation = sign(subject.velocity.x)

func exit():
	$Timer.stop()
	subject.sprite_2d.rotation = 0
	subject.wall_jumped = 0
	
func _on_timer_timeout() -> void:
	subject.wall_jumped = 0
