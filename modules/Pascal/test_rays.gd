extends Node2D

@onready var input_manager: InputManager = %InputManager
@onready var red: Player = $Red

func _ready() -> void:
	input_manager.switchToPlayer(red)
