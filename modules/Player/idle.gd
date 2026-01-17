extends PlayerMovementState

func physics_update(_delta):
	subject.sprite_2d.play("idle")
	if not subject.is_on_floor() and subject.name != "Donkey":
		transition.emit("Jumping")
		subject.sprite_2d.play("jump")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
		
