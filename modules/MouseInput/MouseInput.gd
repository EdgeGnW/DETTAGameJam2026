extends Node

enum Direction { Left, UpLeft, UpRight, Right, DownRight, DownLeft }

@onready var player: CanvasItem = $Karotte
var playerScreenPosition: Vector2
var mousePosition: Vector2
var screenResolution: Vector2

func getRelativeMousePosition() -> Vector2:
	var x = mousePosition.x / screenResolution.x
	var y = mousePosition.y / screenResolution.y
	return Vector2(x, y)
	
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenResolution = get_viewport().get_visible_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mousePosition = get_viewport().get_mouse_position()
	playerScreenPosition = player.get_global_transform_with_canvas().origin
	var vectorToMouse = (mousePosition - playerScreenPosition).normalized();
	var direction = getDirection(vectorToMouse.angle())
	print(Direction.keys()[direction])
