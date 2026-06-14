class_name KeyboardInput extends HexagonalInput


signal back

func rotateDirection(direction: Direction, right: bool) -> Direction:
	var tempDirection = direction + (-1 if right else 1)
	return tempDirection % len(Direction.keys())
	


func _input(event: InputEvent) -> void:
	if not currentlyProcessingInput:
		return
	if event is not InputEventKey:
		return
		
	if event.is_action_pressed("right"):
		currentDirection = Direction.Right
	elif event.is_action_pressed("upRight"):
		currentDirection = Direction.UpRight
	elif event.is_action_pressed("upLeft"):
		currentDirection = Direction.UpLeft
	elif event.is_action_pressed("left"):
		currentDirection = Direction.Left
	elif event.is_action_pressed("downLeft"):
		currentDirection = Direction.DownLeft
	elif event.is_action_pressed("downRight"):
		currentDirection = Direction.DownRight
		
	elif event.is_action_pressed("rotateLeft"):
		currentDirection = rotateDirection(currentDirection, false)
	elif event.is_action_pressed("rotateRight"):
		currentDirection = rotateDirection(currentDirection, true)
		
	elif event.is_action_pressed("relativeRight"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Right)
	elif event.is_action_pressed("relativeUp"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Up)
	elif event.is_action_pressed("relativeLeft"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Left)
	elif event.is_action_pressed("relativeDown"):
		currentDirection = getRelativeDirection(currentDirection, RelativeDirection.Down)
	
	elif event.is_action_pressed("back"):
		back.emit()
	
	super._input(event)
