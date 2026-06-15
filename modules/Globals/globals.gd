extends Node

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }

var menu_position_stack: Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_position_stack = []
	get_tree().paused = not get_tree().paused


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
