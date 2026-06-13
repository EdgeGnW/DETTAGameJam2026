extends Node

signal selectedDirection(direction: HexagonalInput.Direction)

var mouseInput: MouseInput
var keyboardInput: KeyboardInput
var controllerInput: ControllerInput
@export var player: Node2D
var rays: Node2D

func _ready() -> void:
	rays = player.rays
	mouseInput = MouseInput.new()
	mouseInput.setProperties(player, rays)
	mouseInput.confirmSelection.connect(confirmSelectionMouse)
	add_child(mouseInput)
	keyboardInput = KeyboardInput.new()
	keyboardInput.setProperties(player, rays)
	keyboardInput.confirmSelection.connect(confirmSelectionKeyboard)
	add_child(keyboardInput)
	controllerInput = ControllerInput.new()
	controllerInput.setProperties(player, rays)
	controllerInput.confirmSelection.connect(confirmSelectionController)
	add_child(controllerInput)

func confirmSelectionMouse():
	selectedDirection.emit(mouseInput.currentDirection)

func confirmSelectionKeyboard():
	selectedDirection.emit(keyboardInput.currentDirection)

func confirmSelectionController():
	selectedDirection.emit(controllerInput.currentDirection)
	
func reactToInput(active: bool):
	rays.visible = active
	mouseInput.currentlyProcessingInput = active
	keyboardInput.currentlyProcessingInput = active
	controllerInput.currentlyProcessingInput = active
