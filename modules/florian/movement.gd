extends TileMapLayer

const MAX_SEGMENT_LENGTH = 30
const TWEEN_TIME = 0.1

signal gameover

@onready var input_manager: InputManager = %InputManager

var players: Array[Player]
var player_by_color: Dictionary[Vector3i, Player]
var player_paths := {}
var player_directions := {}
var states = []
var player_index: int = 0

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }

var crystal_dict = {
	Vector2i(0, 0): Vector3i(1, 0, 0),
	Vector2i(1, 0): Vector3i(0, 1, 0),
	Vector2i(2, 0): Vector3i(0, 0, 1),
	Vector2i(0, 1): Vector3i(1, 1, 0),
	Vector2i(1, 1): Vector3i(0, 1, 1),
	Vector2i(2, 1): Vector3i(1, 0, 1)
}

func _ready():
	players.assign(find_children("*", "Player", false, false))
	
	for player in players:
		player.grid_position = local_to_map(player.position)
		player.position = map_to_local(player.grid_position)
		player_by_color[player.color] = player
	
	input_manager.go.connect(move_players)
	input_manager.selectedDirection.connect(receive_direction)
	input_manager.back.connect(load_last_state)
	activate_input()

func save_state():
	var state = []
	for player in active_players():
		state.append([player, player.grid_position])
	states.append(state)

func load_last_state():
	if states:
		for player in players:
			player.visible = false
		var state = states.pop_back()
		for player in state:
			player[0].visible = true
			player[0].grid_position = player[1]
			player[0].position = map_to_local(player[1])

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
			move_player(player)
		elif is_prism(grid_position):
			var colors = []
			player.visible = false
			if player.color.x == 1:
				colors.append([player_by_color[Vector3i(1, 0, 0)], 1])
			if player.color.y == 1:
				colors.append([player_by_color[Vector3i(0, 1, 0)], 0])
			if player.color.z == 1:
				colors.append([player_by_color[Vector3i(0, 0, 1)], -1])
			for color in colors:
				color[0].visible = true
				color[0].grid_position = player.grid_position
				color[0].position = player.position
				var color_direction = (6 + direction + color[1]) % 6
				plan_path(color[0], color_direction)
				move_player(color[0])
		elif is_crystal(grid_position):
			var filter = crystal_dict[get_cell_atlas_coords(grid_position)]
			var color = filter * player.color
			if color != player.color:
				# Color got absorbed
				player.visible = false
				var new_player = player_by_color[color]
				new_player.visible = true
				new_player.grid_position = player.grid_position
				new_player.position = player.position
				plan_path(new_player, direction)
				move_player(new_player)
			else:
				plan_path(player, direction)
				move_player(player)


func finish_path(player: Player):
	player_paths.erase(player)
	for p in active_players():
		if p != player and not player_paths.has(p) and player.grid_position == p.grid_position:
			p.visible = false
			player.visible = false
			var joined_color = player_by_color[(p.color + player.color).mini(1)]
			joined_color.visible = true
			joined_color.grid_position = p.grid_position
			joined_color.position = p.position
			break
	if player_paths.is_empty():
		activate_input()
		if players.any(is_off_grid) or lost_color():
			gameover.emit()
	
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
	if player_paths.size() == active_players().size():
		save_state()
		deactivate_input()
		for player in player_paths:
			move_player(player)

func move_player(player: Player):
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
		return Vector2i(source.x+(1 if abs(source.y%2) == 1 else 0), source.y+1)
	elif direction == Direction.DownLeft:
		return Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y+1)
	elif direction == Direction.Left:
		return Vector2i(source.x-1, source.y)
	elif direction == Direction.UpLeft:
		return Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y-1)
	else:
		return Vector2i(source.x+(1 if abs(source.y%2) == 1 else 0), source.y-1)


func is_off_grid(player: Player):
	return not get_viewport().get_visible_rect().has_point(player.global_position)

func lost_color():
	var color = Vector3i(0, 0, 0)
	for player in active_players():
		color += player.color
	return color != Vector3i(1, 1, 1)


func get_player_of_color(color: Vector3i):
	for player in players:
		if player.color == color:
			return player


func deactivate_input():
	print("deactivate input")
	input_manager.reactToInput(false)

func activate_input():
	print("activate input")
	input_manager.switchToPlayer(active_players()[0])
	input_manager.reactToInput(true)
	player_index = 0
	active_players()[player_index].rays.activate()



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
	
func is_crystal(pos: Vector2i) -> bool:
	return tile_type(pos) == 4
