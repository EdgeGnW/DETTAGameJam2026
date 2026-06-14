class_name ControllerInput extends HexagonalInput

func _input(event: InputEvent) -> void:
	if not currentlyProcessingInput:
		return
	if event is InputEventJoypadMotion:
		if event.is_action_pressed("confirmDirection") or event.is_action_pressed("go"):
			pass
		else:
			var joystickDirection: Vector2 = Input.get_vector("left", "right", "controllerUp", "controllerDown")
			if joystickDirection.length() < 0.7:
				return
			currentDirection = angleToDirection(joystickDirection.angle())
	elif event is not InputEventJoypadButton:
		return
	if event.is_action_pressed("relativeRight"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Right)
	elif event.is_action_pressed("relativeUp"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Up)
	elif event.is_action_pressed("relativeLeft"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Left)
	elif event.is_action_pressed("relativeDown"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Down)
		
	super._input(event)
