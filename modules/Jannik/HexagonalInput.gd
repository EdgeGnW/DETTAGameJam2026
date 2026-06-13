class_name HexagonalInput extends Node

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }
enum RelativeDirection { Right, Up, Left, Down }
var currentDirection: Direction
var player: Node2D
var rays: Node2D

func setProperties(player: Node2D, rays: Node2D) -> void:
	print('set properties')
	self.player = player
	self.rays = rays

func angleToDirection(angle: float) -> Direction:
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

func _input(event: InputEvent) -> void:
	rays.highlight_ray(currentDirection)

func getRelativeDirection(startingDirection: Direction, modifier: RelativeDirection) -> Direction:
	match currentDirection:
		Direction.Right:
			match modifier:
				RelativeDirection.Up:
					return Direction.UpRight
				RelativeDirection.Down:
					return Direction.DownRight
				RelativeDirection.Left:
					return Direction.Left
		Direction.UpRight:
			match modifier:
				RelativeDirection.Down, RelativeDirection.Right:
					return Direction.Right
				RelativeDirection.Left:
					return Direction.UpLeft
		Direction.UpLeft:
			match modifier:
				RelativeDirection.Down, RelativeDirection.Left:
					return Direction.Left
				RelativeDirection.Right:
					return Direction.UpRight
		Direction.Left:
			match modifier:
				RelativeDirection.Up:
					return Direction.UpLeft
				RelativeDirection.Down:
					return Direction.DownLeft
				RelativeDirection.Right:
					return Direction.Right
		Direction.DownLeft:
			match modifier:
				RelativeDirection.Right:
					return Direction.DownRight
				RelativeDirection.Left, RelativeDirection.Up:
					return Direction.Left
		Direction.DownRight:
			match modifier:
				RelativeDirection.Up, RelativeDirection.Right:
					return Direction.Right
				RelativeDirection.Left:
					return Direction.DownLeft
	
	return startingDirection
