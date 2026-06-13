class_name InputManager
extends Node

signal selectedDirection(direction: HexagonalInput.Direction)
signal go

var mouseInput: MouseInput
var keyboardInput: KeyboardInput
var controllerInput: ControllerInput
@export var player: Player

func _ready() -> void:
	mouseInput = MouseInput.new()
	mouseInput.setProperties(player, player.rays)
	mouseInput.confirmSelection.connect(confirmSelectionMouse)
	mouseInput.go.connect(func(): go.emit())
	add_child(mouseInput)
	keyboardInput = KeyboardInput.new()
	keyboardInput.setProperties(player, player.rays)
	keyboardInput.confirmSelection.connect(confirmSelectionKeyboard)
	keyboardInput.go.connect(func(): go.emit())
	add_child(keyboardInput)
	controllerInput = ControllerInput.new()
	controllerInput.setProperties(player, player.rays)
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
	player.rays.activate()
	mouseInput.currentlyProcessingInput = active
	keyboardInput.currentlyProcessingInput = active
	controllerInput.currentlyProcessingInput = active
