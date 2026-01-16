extends PlayerMovementState

func physics_update(delta):
	if not subject.is_on_floor():
		transition.emit("Jumping")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
		
