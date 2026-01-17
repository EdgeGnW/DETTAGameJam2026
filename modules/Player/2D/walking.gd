extends PlayerMovementState

func physics_update(_delta):
	
	if not subject.is_on_floor() and subject.name != "Donkey":
		transition.emit("Jumping")
	elif subject.velocity.x == 0.0:
		transition.emit("Idle")
	#elif Input.is_action_pressed("roll"):
	#	transition.emit("Rolling")
	#else:
		#subject.sprite_2d.rotation = 0.25 * sign(subject.velocity.x)

func exit():
	subject.sprite_2d.rotation = 0
