extends PlayerMovementState

var rotation: int
	
func physics_update(_delta):
	if not subject.animal_state == AnimalState.Animal_state.ACTIVE:
		transition.emit("Idle")
	elif not subject.is_on_floor():
		if subject.is_on_wall() and subject.name == "Cat" and subject.raycast.is_colliding():
			transition.emit("WallSliding")
		if subject.sprite_2d.animation == "jump" and subject.velocity.y > 0:
			subject.sprite_2d.play("fall")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
	else:
		transition.emit("Idle")
		

func enter():
	subject.sprite_2d.play("jump")
