class_name MouseInput extends HexagonalInput

var playerScreenPosition: Vector2
var mousePosition: Vector2
var screenResolution: Vector2

func getRelativeMousePosition() -> Vector2:
	var x: float = mousePosition.x / screenResolution.x
	var y: float = mousePosition.y / screenResolution.y
	return Vector2(x, y)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenResolution = get_viewport().get_visible_rect().size

func _input(event: InputEvent) -> void:
	if not currentlyProcessingInput:
		return
	if event is not InputEventMouseMotion and event is not InputEventMouseButton:
		return
	if Input.is_anything_pressed() and event is not InputEventMouseButton:
		return
	mousePosition = get_viewport().get_mouse_position()
	playerScreenPosition = player.get_global_transform_with_canvas().origin
	var vectorToMouse: Vector2 = (mousePosition - playerScreenPosition).normalized();
	currentDirection = angleToDirection(vectorToMouse.angle())
	super._input(event)
