extends Node

@onready var player: CharacterBody2D = %Player
@onready var inputManager: Node = %InputManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inputManager.selectedDirection.connect(_selectedDirection)
	inputManager.reactToInput(true)


func _selectedDirection(direction: HexagonalInput.Direction):
	inputManager.reactToInput(false)
	print(HexagonalInput.directionVectors.get(direction))
	player.move(HexagonalInput.directionVectors.get(direction))
