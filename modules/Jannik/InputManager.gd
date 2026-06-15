class_name InputManager
extends Node

signal selectedDirection(direction: HexagonalInput.Direction)
signal abortDirection
signal go
signal reset
signal back
signal switchPlayer(direction: int)

var mouseInput: MouseInput
var keyboardInput: KeyboardInput
var controllerInput: ControllerInput

func _ready() -> void:
	mouseInput = MouseInput.new()
	mouseInput.confirmSelection.connect(confirmSelectionMouse)
	mouseInput.abortSelection.connect(func(): abortDirection.emit())
	mouseInput.go.connect(func(): go.emit())
	mouseInput.switchPlayer.connect(func(n): switchPlayer.emit(n))
	add_child(mouseInput)
	keyboardInput = KeyboardInput.new()
	keyboardInput.confirmSelection.connect(confirmSelectionKeyboard)
	keyboardInput.abortSelection.connect(func(): abortDirection.emit())
	keyboardInput.go.connect(func(): go.emit())
	keyboardInput.back.connect(func(): back.emit())
	keyboardInput.reset.connect(func(): reset.emit())
	keyboardInput.switchPlayer.connect(func(n): switchPlayer.emit(n))
	add_child(keyboardInput)
	controllerInput = ControllerInput.new()
	controllerInput.confirmSelection.connect(confirmSelectionController)
	controllerInput.abortSelection.connect(func(): abortDirection.emit())
	controllerInput.go.connect(func(): go.emit())
	controllerInput.switchPlayer.connect(func(n): switchPlayer.emit(n))
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

	
