extends PlayerMovementState

var rotation: int
	
func physics_update(_delta):
	if not subject.animal_state == AnimalState.Animal_state.ACTIVE:
		transition.emit("Idle")
	elif not subject.is_on_floor():
		if subject.is_on_wall() and subject.name == "Cat":
			transition.emit("WallSliding")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
	else:
		transition.emit("Idle")
		
#func update(delta):
#	subject.sprite_2d.rotate(delta * 10 * rotation)

func enter():
	rotation = subject.dir

func exit():
	subject.sprite_2d.rotation = 0
