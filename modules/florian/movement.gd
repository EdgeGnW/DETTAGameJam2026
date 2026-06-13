extends TileMapLayer

const MAX_SEGMENT_LENGTH = 30
const TWEEN_TIME = 0.1

@onready var input_manager: InputManager = %InputManager

var players: Array[Player]
var player_paths := {}
var player_index: int = 0

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }

static var Neighbor: Dictionary = {
	Direction.Left: Vector2i(-1, 0),
	Direction.UpLeft: Vector2i(0, -1),
	Direction.UpRight: Vector2i(1, -1),
	Direction.Right: Vector2i(1, 0),
	Direction.DownRight: Vector2i(1, 1),
	Direction.DownLeft: Vector2i(0, 1),
}

func _ready():
	players.assign(find_children("*", "Player", false, false))
	
	for player in players:
		player.grid_position = local_to_map(player.position)
		player.position = map_to_local(player.grid_position)

	input_manager.go.connect(move_players)
	input_manager.selectedDirection.connect(receive_direction)
	input_manager.reactToInput(true)

func plan_path(player: Player, direction: Direction):
	var old_position = player.grid_position
	for i in range(MAX_SEGMENT_LENGTH):
		var new_position = next_tile(old_position, direction)
		print(old_position)
		if get_cell_tile_data(new_position):
			if is_wall(new_position):
				break
			elif is_mirror(new_position):
				old_position = new_position
				break
		old_position = new_position
	player_paths[player] = old_position
	
func receive_direction(direction: Direction):
	print(players)
	print(active_players())
	var current_player = active_players()[player_index]
	current_player.rays.deactivate()
	plan_path(current_player, direction)
	advance_player_index(1)
	
func advance_player_index(direction: int):
	player_index = (player_index + direction) % len(active_players())
	active_players()[player_index].rays.activate()
	
func active_players() -> Array[Player]:
	#for player in players:
		#print(player, player.visible)
	return players.filter(func(player): return player.visible)

func move_players():
	
	for player in player_paths:
		if player.tween:
			player.skip_tween()
		player.tween = create_tween()
		var value = player_paths[player]
		var final_position = map_to_local(value)
		var distance = (map_to_local(player.grid_position)-final_position).length()
		player.tween.tween_property(player, "position", final_position, TWEEN_TIME * distance / tile_set.tile_size.x) #multiply by amount
		player.grid_position = value

func next_tile(source: Vector2i, direction: Direction) -> Vector2i:
	if direction == Direction.Right:
		return Vector2i(source.x+1, source.y)
	elif direction == Direction.DownRight:
		return Vector2i(source.x+(1 if source.y%2 == 1 else 0), source.y+1)
	elif direction == Direction.DownLeft:
		return Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y+1)
	elif direction == Direction.Left:
		return Vector2i(source.x-1, source.y)
	elif direction == Direction.UpLeft:
		return Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y-1)
	else:
		return Vector2i(source.x+(1 if source.y%2 == 1 else 0), source.y-1)


#TODO richtige Werte für Mirrors, Walls, etc.
func tile_type(pos: Vector2i) -> int:
	if get_cell_tile_data(pos):
		return get_cell_source_id(pos)
	return 0;

func is_wall(pos: Vector2i) -> bool:
	return tile_type(pos) == 1

func is_mirror(pos: Vector2i) -> bool:
	var type = tile_type(pos)
	return type > 1 and type < 20

func is_prism(pos: Vector2i) -> bool:
	return tile_type(pos) == 20
