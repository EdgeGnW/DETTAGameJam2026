extends PlayerMovementState

var rotation: int

func update(delta):
	subject.sprite_2d.rotate(delta * 20 * rotation)

func enter():
	$Timer.start()
	rotation = sign(subject.velocity.x)
	subject.sprite_2d.scale.y = 0.6
	subject.movement_locked = true

func exit():
	subject.sprite_2d.rotation = 0
	subject.sprite_2d.scale.y = 1.0
	subject.movement_locked = false
	$Timer.stop()

func _on_timer_timeout() -> void:
	if not subject.is_on_floor():
		transition.emit("Jumping")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
	else:
		transition.emit("Idle")
