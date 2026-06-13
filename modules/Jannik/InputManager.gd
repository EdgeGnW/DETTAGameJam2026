extends Node

var mouseInput: MouseInput
var keyboardInput: KeyboardInput
var controllerInput: ControllerInput
@export var player: Node2D
@export var rays: Node2D

func _ready() -> void:
	#print('waiting for player')
	#var player = %Player
	#await player.ready
	#print('player ready')
	mouseInput = MouseInput.new()
	mouseInput.setProperties(player, rays)
	add_child(mouseInput)
	keyboardInput = KeyboardInput.new()
	keyboardInput.setProperties(player, rays)
	add_child(keyboardInput)
	controllerInput = ControllerInput.new()
	controllerInput.setProperties(player, rays)
	add_child(controllerInput)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
