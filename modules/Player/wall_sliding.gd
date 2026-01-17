extends PlayerMovementState

var MAX_SLIDE_SPEED: float = 50

func physics_update(_delta):
	if not subject.is_on_floor():
		if subject.is_on_wall() and Input.is_action_just_pressed("ui_accept") and subject.name == "Cat":
			transition.emit("WallJumping")
		elif not subject.is_on_wall():
			transition.emit("Jumping")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
	else:
		transition.emit("Idle")
	
	subject.velocity.y = clamp(subject.velocity.y, -1000, MAX_SLIDE_SPEED)
