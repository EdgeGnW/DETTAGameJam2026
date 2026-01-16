extends PlayerMovementState

var rotation: int
	
func physics_update(_delta):
	if not subject.is_on_floor():
		if subject.is_on_wall() and Input.is_action_just_pressed("ui_accept"):
			transition.emit("WallJumping")
	elif subject.velocity.x != 0.0:
		transition.emit("Walking")
	else:
		transition.emit("Idle")
		
func update(delta):
	subject.sprite_2d.rotate(delta * 10 * rotation)

func enter():
	rotation = subject.dir

func exit():
	subject.sprite_2d.rotation = 0
