class_name InputManager
extends Node

signal selectedDirection(direction: HexagonalInput.Direction)
signal go
signal back

var mouseInput: MouseInput
var keyboardInput: KeyboardInput
var controllerInput: ControllerInput

func _ready() -> void:
	mouseInput = MouseInput.new()
	mouseInput.confirmSelection.connect(confirmSelectionMouse)
	mouseInput.go.connect(func(): go.emit())
	add_child(mouseInput)
	keyboardInput = KeyboardInput.new()
	keyboardInput.confirmSelection.connect(confirmSelectionKeyboard)
	keyboardInput.go.connect(func(): go.emit())
	keyboardInput.back.connect(func(): back.emit())
	add_child(keyboardInput)
	controllerInput = ControllerInput.new()
	controllerInput.confirmSelection.connect(confirmSelectionController)
	controllerInput.go.connect(func(): go.emit())
	add_child(controllerInput)

func confirmSelectionMouse():
	selectedDirection.emit(mouseInput.currentDirection)

func confirmSelectionKeyboard():
	selectedDirection.emit(keyboardInput.currentDirection)

func confirmSelectionController():
	selectedDirection.emit(controllerInput.currentDirection)
	
func reactToInput(active: bool):
	#player.rays.activate()
	mouseInput.currentlyProcessingInput = active
	keyboardInput.currentlyProcessingInput = active
	controllerInput.currentlyProcessingInput = active
	
func switchToPlayer(player: Player):
	mouseInput.setProperties(player)
	keyboardInput.setProperties(player)
	controllerInput.setProperties(player)

	
