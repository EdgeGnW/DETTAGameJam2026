extends SceneTile

enum mirrorType {OneWay, TwoWay}

@export var angle: float

func interact(directionIn: Globals.Direction, color: Globals.PlayerColor) -> Globals.Direction:
	return directionIn

func _ready() -> void:
	pass
