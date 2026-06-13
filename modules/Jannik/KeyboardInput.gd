extends Node

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }
var lastDirectionPressed: Direction


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		lastDirectionPressed = Direction.Right
	if event.is_action_pressed("upRight"):
		lastDirectionPressed = Direction.UpRight
	if event.is_action_pressed("upLeft"):
		lastDirectionPressed = Direction.UpLeft
	if event.is_action_pressed("left"):
		lastDirectionPressed = Direction.Left
	if event.is_action_pressed("downLeft"):
		lastDirectionPressed = Direction.DownLeft
	if event.is_action_pressed("downRight"):
		lastDirectionPressed = Direction.DownRight
