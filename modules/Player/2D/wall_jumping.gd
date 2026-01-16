extends PlayerMovementState

var rotation: int
var normal: Vector2
	
func physics_update(delta):
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
	normal = subject.get_wall_normal()
	subject.velocity.x = sign(normal.x) * subject.SPEED
	subject.jump()
	subject.movement_locked = true
	$Timer.start()
	rotation = sign(subject.velocity.x)

func exit():
	$Timer.stop()
	subject.sprite_2d.rotation = 0
	subject.movement_locked = false
	
func _on_timer_timeout() -> void:
	subject.movement_locked = false
