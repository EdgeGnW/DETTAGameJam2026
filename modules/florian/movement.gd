extends TileMapLayer

const MAX_SEGMENT_LENGTH = 30
const TWEEN_TIME = 0.1

@onready var input_manager: InputManager = %InputManager

var players: Array[Player]
var player_paths := {}
var player_directions := {}
var player_index: int = 0

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }

func _ready():
	players.assign(find_children("*", "Player", false, false))
	
	for player in players:
		player.grid_position = local_to_map(player.position)
		player.position = map_to_local(player.grid_position)

	input_manager.go.connect(move_players)
	input_manager.selectedDirection.connect(receive_direction)
	activate_input()

func plan_path(player: Player, direction: Direction):
	var path_to = player.grid_position
	for i in range(MAX_SEGMENT_LENGTH):
		var new_position = next_tile(path_to, direction)
		if get_cell_tile_data(new_position):
			if is_wall(new_position):
				break
			if is_mirror(new_position):
				var mirror_type = get_cell_atlas_coords(new_position)
				var new_direction = (15 - direction - mirror_type.x) % 6
				if new_direction == direction:
					# Hit mirror's edge -> Act as wall
					break
			path_to = new_position
			break
		path_to = new_position
	player_paths[player] = path_to
	player_directions[player] = direction
	
func check_final_position(player: Player):
	var grid_position = player_paths[player]
	var direction = player_directions[player]
	assert(local_to_map(player.position) == grid_position, "We did not arrive at the planned final position")
	player.grid_position = grid_position
	if get_cell_tile_data(grid_position):
		if is_mirror(grid_position):
			var mirror_type = get_cell_atlas_coords(grid_position)
			var new_direction = (15 - direction - mirror_type.x) % 6
			if mirror_type.y > 0 and (direction + (mirror_type.x + 6 * (mirror_type.y - 1)) / 2) % 6 in [5, 0, 1]:
				# Hit one-way mirror's backside -> Go through
				new_direction = direction
			else:
				# Hit mirror -> Reflect
				direction = new_direction
			plan_path(player, direction)
			var final_position = map_to_local(player_paths[player])
			var distance = (map_to_local(player.grid_position)-final_position).length()
			player.skip_tween()
			player.tween = create_tween()
			player.tween.tween_property(player, "position", final_position, TWEEN_TIME * distance / tile_set.tile_size.x) #multiply by amount
			player.tween.tween_callback(check_final_position.bind(player))
			player.tween.tween_callback(finish_path.bind(player))
		elif is_prism(grid_position):
			var colors = []
			if player == $White:
				player.visible = false
				colors = [[$Blue, -1], [$Yellow, 0], [$Red, 1]]
			elif player == $Orange:
				player.visible = false
				colors = [[$Yellow, 0], [$Red, 1]]
			elif player == $Green:
				player.visible = false
				colors = [[$Blue, -1], [$Yellow, 0]]
			elif player == $Violet:
				player.visible = false
				colors = [[$Blue, -1], [$Red, 1]]
			elif player == $Blue:
				colors = [[$Blue, -1]]
			elif player == $Yellow:
				colors = [[$Yellow, 0]]
			elif player == $Red:
				colors = [[$Red, 1]]
			for color in colors:
				color[0].visible = true
				color[0].grid_position = player.grid_position
				color[0].position = player.position
				var color_direction = (6 + direction + color[1]) % 6
				plan_path(color[0], color_direction)
				if color[0].tween:
					color[0].skip_tween()
				color[0].tween = create_tween()
				var final_position = map_to_local(player_paths[color[0]])
				var distance = (map_to_local(color[0].grid_position)-final_position).length()
				color[0].tween.tween_property(color[0], "position", final_position, TWEEN_TIME * distance / tile_set.tile_size.x) #multiply by amount
				color[0].tween.tween_callback(check_final_position.bind(color[0]))
				color[0].tween.tween_callback(finish_path.bind(color[0]))


func finish_path(player: Player):
	player_paths.erase(player)
	for p in active_players():
		if p != player and not player_paths.has(p) and player.grid_position == p.grid_position:
			p.visible = false
			player.visible = false
			var joined_color = p
			if (p == $Blue and player == $Yellow) or (p == $Yellow and player == $Blue):
				joined_color = $Green
			elif (p == $Blue and player == $Red) or (p == $Red and player == $Blue):
				joined_color = $Violet
			elif (p == $Red and player == $Yellow) or (p == $Yellow and player == $Red):
				joined_color = $Orange
			else:
				joined_color = $White
			joined_color.visible = true
			joined_color.grid_position = p.grid_position
			joined_color.position = p.position
			break
	if player_paths.is_empty():
		activate_input()
	
func receive_direction(direction: Direction):
	var current_player = active_players()[player_index]
	current_player.rays.deactivate()
	plan_path(current_player, direction)
	advance_player_index(1)
	
func advance_player_index(direction: int):
	player_index = (player_index + direction) % len(active_players())
	var current_player = active_players()[player_index]
	current_player.rays.activate()
	input_manager.switchToPlayer(current_player)
	
	
func active_players() -> Array[Player]:
	return players.filter(func(player): return player.visible)

func move_players():
	deactivate_input()
	for player in player_paths:
		if player.tween:
			player.skip_tween()
		player.tween = create_tween()
		var final_position = map_to_local(player_paths[player])
		var distance = (map_to_local(player.grid_position)-final_position).length()
		player.tween.tween_property(player, "position", final_position, TWEEN_TIME * distance / tile_set.tile_size.x) #multiply by amount
		player.tween.tween_callback(check_final_position.bind(player))
		player.tween.tween_callback(finish_path.bind(player))

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


func deactivate_input():
	print("deactivate input")
	input_manager.reactToInput(false)

func activate_input():
	print("activate input")
	input_manager.switchToPlayer(active_players()[0])
	input_manager.reactToInput(true)
	player_index = 0
	active_players()[player_index].rays.activate()

#TODO richtige Werte für Mirrors, Walls, etc.
func tile_type(pos: Vector2i) -> int:
	if get_cell_tile_data(pos):
		return get_cell_source_id(pos)
	return 0;

func is_wall(pos: Vector2i) -> bool:
	return tile_type(pos) == 1

func is_mirror(pos: Vector2i) -> bool:
	return tile_type(pos) == 2

func is_prism(pos: Vector2i) -> bool:
	return tile_type(pos) == 3
