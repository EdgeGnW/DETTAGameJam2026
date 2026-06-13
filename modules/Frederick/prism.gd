extends SceneTile

func interact(directionIn: Globals.Direction, color: Globals.PlayerColor) -> Globals.Direction:
	if color == Globals.PlayerColor.Yellow:
		return directionIn
	elif color == Globals.PlayerColor.Red:
		return (directionIn + 1) % 6
	return (directionIn - 1) % 6
