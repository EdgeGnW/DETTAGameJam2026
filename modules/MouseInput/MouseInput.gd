class_name MouseInput extends HexagonalInput

var playerScreenPosition: Vector2
var mousePosition: Vector2
var screenResolution: Vector2
var directionVectors: Dictionary = {
	Direction.Left: Vector2(-1, 0),
	Direction.UpLeft: Vector2(-0.5, -0.866),
	Direction.UpRight: Vector2(0.5, -0.866),
	Direction.Right: Vector2(1, 0),
	Direction.DownRight: Vector2(0.5, 0.866),
	Direction.DownLeft: Vector2(-0.5, 0.866),
}

func getRelativeMousePosition() -> Vector2:
	var x: float = mousePosition.x / screenResolution.x
	var y: float = mousePosition.y / screenResolution.y
	return Vector2(x, y)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenResolution = get_viewport().get_visible_rect().size
	print(player)

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	mousePosition = get_viewport().get_mouse_position()
	playerScreenPosition = player.get_global_transform_with_canvas().origin
	var vectorToMouse: Vector2 = (mousePosition - playerScreenPosition).normalized();
	currentDirection = angleToDirection(vectorToMouse.angle())
	super._input(event)
