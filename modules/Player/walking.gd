extends PlayerMovementState

func physics_update(_delta):
	if not subject.is_on_floor() and subject.name != "Donkey":
		transition.emit("Jumping")
	elif subject.velocity.x == 0.0:
		transition.emit("Idle")
		
func enter():
	subject.sprite_2d.play("walk")
