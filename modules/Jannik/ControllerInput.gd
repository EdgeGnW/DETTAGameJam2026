extends Node

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }
var lastPressedDirection: Direction

func _input(event: InputEvent) -> void:
	var joystickDirection = Input.get_vector("left", "right", "up", "down")
	if joystickDirection.length() < 0.5:
		return
	lastPressedDirection = getDirection(joystickDirection.angle())

func getDirection(angle: float) -> Direction:
	if (-PI/6 <= angle && angle <= PI/6):
		return Direction.Right
	if (PI/6 <= angle && angle <= PI/2):
		return Direction.DownRight
	if (PI/2 <= angle && angle <= PI*5/6):
		return Direction.DownLeft
	if (PI*5/6 <= angle || angle <= -PI*5/6):
		return Direction.Left
	if (-PI*5/6 <= angle && angle <= -PI*3/6):
		return Direction.UpLeft
	if (-PI*3/6 <= angle && angle <= -PI/6):
		return Direction.UpRight
	return Direction.Left
