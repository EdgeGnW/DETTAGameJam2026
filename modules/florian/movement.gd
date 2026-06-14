extends TileMapLayer

const MAX_SEGMENT_LENGTH = 16
const TWEEN_TIME = 0.1

signal win
signal gameover

@onready var input_manager: InputManager = %InputManager

var players: Array[Player]
var player_by_color: Dictionary[Vector3i, Player]
var player_paths := {}
var player_directions := {}
var states = []
var player_index: int = 0

var color_in_goal: Vector3i = Vector3i(0, 0, 0)

enum Direction { Right, UpRight, UpLeft, Left, DownLeft, DownRight }

var crystal_dict = {
	Vector2i(0, 0): Vector3i(1, 0, 0),
	Vector2i(1, 0): Vector3i(0, 1, 0),
	Vector2i(2, 0): Vector3i(0, 0, 1),
	Vector2i(0, 1): Vector3i(1, 1, 0),
	Vector2i(1, 1): Vector3i(0, 1, 1),
	Vector2i(2, 1): Vector3i(1, 0, 1)
}

const LOST_OR_STUCK := preload("uid://ca0elmi7h67j7")
var move_arr := [preload("uid://bq7wgbobex3th"),
	preload("uid://bey48i72g40e6"),
	preload("uid://c8sqv02j0lmk2")]
var mirror_prism_arr := [preload("uid://boc8t2s3ewshq"),
	preload("uid://chkdh7h52v6d4"),
	preload("uid://dkrffrl7cfo6t")]
var merge_arr := [
	preload("uid://vb31rogtjk0r"),
	preload("uid://bfak6j8wujqr0"),
	preload("uid://b2yhtid1jn54o")
]
const WALL := preload("uid://mdqugeutjoq6")
const WON := preload("uid://bt265jl41dxhh")
const BACKGROUND = preload("uid://cyxjd7iirwu10")

var black_holes := {}
var close_to_black_holes := {}

func _ready():
	var background = BACKGROUND.instantiate()
	add_child.call_deferred(background)
	
	players.assign(find_children("*", "Player", false, false))
	
	for player in players:
		player.grid_position = local_to_map(player.position)
		player.position = map_to_local(player.grid_position)
		player_by_color[player.color] = player
	
	for i in range(30):
		for j in range(30):
			var cell = Vector2i(i, j)
			if get_cell_source_id(cell) == 6:
				black_holes[cell] = [0, 0, cell]
				for direction in range(6):
					var next_cell = next_tile(cell, direction)
					var inverse_direction = (3 + direction)%6
					black_holes[next_cell] = [1, inverse_direction, cell]
					black_holes[next_tile(next_cell, direction)] = [2, inverse_direction, cell]
					black_holes[next_tile(next_cell, (direction + 1)%6)] = [3, inverse_direction, cell]
	
	win.connect(Menu._on_level_complete)
	Menu.undo_last_move.connect(load_last_state_and_activate_input)
	gameover.connect(Menu._on_game_over)
	
	input_manager.go.connect(move_players)
	input_manager.selectedDirection.connect(receive_direction)
	input_manager.back.connect(load_last_state_and_activate_input)
	input_manager.reset.connect(load_first_state)
	input_manager.switchPlayer.connect(switch_player_index)
	activate_input()

func save_state():
	var state = [color_in_goal]
	for player in active_players():
		state.append([player, player.grid_position])
	states.append(state)

func load_last_state():
	if states:
		for player in players:
			player.visible = false
		var state = states.pop_back()
		color_in_goal = state.pop_front()
		close_to_black_holes = {}
		for player in state:
			player[0].clean_effects()
			player[0].visible = true
			player[0].grid_position = player[1]
			player[0].position = map_to_local(player[1])

func load_first_state():
	if states:
		for player in players:
			player.visible = false
		var state = states.pop_front()
		color_in_goal = state.pop_front()
		close_to_black_holes = {}
		for player in state:
			player[0].clean_effects()
			player[0].visible = true
			player[0].grid_position = player[1]
			player[0].position = map_to_local(player[1])
		states = []
		activate_input()

func load_last_state_and_activate_input():
	load_last_state()
	activate_input()

func plan_path(player: Player, direction: Direction):
	var path_to = player.grid_position
	for i in range(MAX_SEGMENT_LENGTH):
		var new_position = next_tile(path_to, direction)
		if get_cell_tile_data(new_position):
			if is_wall(new_position, direction):
				break
			path_to = new_position
			if path_to not in black_holes.keys():
				close_to_black_holes.erase(player)
			break
		path_to = new_position
		if path_to in black_holes.keys():
			if close_to_black_holes.get(player, 0) + black_holes[path_to][0] < 3:
				break
		else:
			close_to_black_holes.erase(player)
	player_paths[player] = path_to
	player_directions[player] = direction
	
	
func check_final_position(player: Player):
	var grid_position = player_paths[player]
	var direction = player_directions[player]
	assert(local_to_map(player.position) == grid_position, "We did not arrive at the planned final position")
	player.grid_position = grid_position
	if get_cell_tile_data(grid_position):
		if is_mirror(grid_position):
			AudioManager.play_random_sound(mirror_prism_arr)
			var mirror_type = get_cell_atlas_coords(grid_position)
			var new_direction = (15 - direction - mirror_type.x) % 6
			if mirror_type.y > 0 and (direction + (mirror_type.x + 6 * (mirror_type.y - 1)) / 2) % 6 in [5, 0, 1]:
				# Hit one-way mirror's backside -> Go through
				new_direction = direction
			else:
				# Hit mirror -> Reflect
				direction = new_direction
			plan_path(player, direction)
			player.clean_effects()
			move_player(player)
		elif is_prism(grid_position):
			AudioManager.play_random_sound(mirror_prism_arr)
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
				if player in close_to_black_holes.keys():
					close_to_black_holes[color[0]] = close_to_black_holes[player]
				var color_direction = (6 + direction + color[1]) % 6
				plan_path(color[0], color_direction)
				move_player(color[0])
		elif is_crystal(grid_position):
			var filter = crystal_dict[get_cell_atlas_coords(grid_position)]
			var color = filter * player.color
			if color != player.color:
				# Color got absorbed
				player.visible = false
				if color.length() != 0:
					var new_player = player_by_color[color]
					new_player.visible = true
					new_player.grid_position = player.grid_position
					new_player.position = player.position
					if player in close_to_black_holes.keys():
						close_to_black_holes[new_player] = close_to_black_holes[player]
					plan_path(new_player, direction)
					move_player(new_player)
			else:
				plan_path(player, direction)
				move_player(player)
		elif is_goal(grid_position):
			color_in_goal += player.color
		elif is_black_hole(grid_position):
			# Color got absorbed
			player.visible = false
	elif grid_position in black_holes.keys():
		AudioManager.play_sound(WALL)
		var black_hole = black_holes[grid_position]
		if close_to_black_holes.get(player, 0) + black_hole[0] < 3:
			var new_direction = direction
			if black_hole[0] >= 1 and (6 + direction - black_hole[1]) % 6 in [2, 3, 4]:
				new_direction = (6 + 2 * direction - ((3 + black_hole[1]) % 6)) % 6
				close_to_black_holes[player] = close_to_black_holes.get(player, 0) + 1
				plan_path(player, new_direction)
				move_player(player)
			elif is_wall(next_tile(grid_position, direction), direction): # TODO: Mirror's Edge
				player_paths[player] = black_hole[2]
				move_player(player)
			else:
				plan_path(player, direction)
				move_player(player)
		else:
			player_paths[player] = black_hole[2]
			move_player(player)
	else:
		AudioManager.play_sound(WALL)


func finish_path(player: Player):
	player_paths.erase(player)
	for p in active_players():
		if p != player and not player_paths.has(p) and player.grid_position == p.grid_position:
			AudioManager.play_random_sound(merge_arr)
			p.visible = false
			player.visible = false
			var joined_color = player_by_color[(p.color + player.color).mini(1)]
			joined_color.visible = true
			joined_color.grid_position = p.grid_position
			joined_color.position = p.position
			break
	if player_paths.is_empty():
		if color_in_goal == Vector3i(1, 1, 1):
			win.emit()
			AudioManager.play_sound(WON)
			animate_goal(true)
			player = get_player_of_color(Vector3i(1,1,1))
			player.tween = create_tween()
			player.tween.tween_property(player.sprite, "modulate:a", 0, 0.2)
			
		elif active_players().any(is_off_grid) or lost_color():
			gameover.emit()
			AudioManager.play_sound(LOST_OR_STUCK)
		else:
			activate_input()
		
	
func animate_goal(active: bool) -> void:
	if active:
		var pos = players.get(0).grid_position
		set_cell(pos, 5, Vector2i(0,1))
		await get_tree().create_timer(0.39).timeout
		set_cell(pos, 5, Vector2i(0,2))
	

func receive_direction(direction: Direction):
	var current_player = active_players()[player_index]
	current_player.rays.select_ray()
	#current_player.rays.deactivate()
	plan_path(current_player, direction)
	#advance_player_index(1)
	
func switch_player_index(direction: int):
	var current_player = active_players()[player_index]
	current_player.rays.deactivate()
	player_index = (player_index + direction) % len(active_players())
	current_player = active_players()[player_index]
	current_player.rays.activate()
	input_manager.switchToPlayer(current_player)
	
	
func visible_players() -> Array[Player]:
	return players.filter(func(player): return player.visible)
	
func active_players() -> Array[Player]:
	return visible_players().filter(func(player): return player.color != color_in_goal)

func move_players():
	if active_players().size() == 1 and player_paths.size() == 0 and active_players()[0].sceneToEnter:
		SceneManager.update_current_scene(active_players()[0].sceneToEnter)
		return
	if player_paths.size() == active_players().size():
		save_state()
		deactivate_input()
		for player in player_paths:
			move_player(player)

func move_player(player: Player):
	player.rays.reset()
	if player.tween:
		player.skip_tween()
	player.tween = create_tween()
	AudioManager.play_random_sound(move_arr)
	var final_position = map_to_local(player_paths[player])
	var distance = (map_to_local(player.grid_position)-final_position).length()
	player.tween.tween_property(player, "position", final_position, TWEEN_TIME * distance / tile_set.tile_size.x) #multiply by amount
	player.tween.tween_callback(check_final_position.bind(player))
	player.tween.tween_callback(finish_path.bind(player))
	player.tween.tween_callback(player.clean_effects)
	

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
	for player in visible_players():
		color += player.color
	return color != Vector3i(1, 1, 1)


func get_player_of_color(color: Vector3i):
	for player in players:
		if player.color == color:
			return player


func deactivate_input():
	input_manager.reactToInput(false)

func activate_input():
	input_manager.switchToPlayer(active_players()[0])
	input_manager.reactToInput(true)
	player_index = 0
	active_players()[player_index].rays.activate()
	print("Test")



func tile_type(pos: Vector2i) -> int:
	if get_cell_tile_data(pos):
		return get_cell_source_id(pos)
	return 0;

func is_wall(pos: Vector2i, direction: Direction) -> bool:
	return tile_type(pos) == 1 or (is_mirror(pos) and (15 - direction - get_cell_atlas_coords(pos).x) % 6 == direction)

func is_mirror(pos: Vector2i) -> bool:
	return tile_type(pos) == 2

func is_prism(pos: Vector2i) -> bool:
	return tile_type(pos) == 3
	
func is_crystal(pos: Vector2i) -> bool:
	return tile_type(pos) == 4
	
func is_goal(pos: Vector2i) -> bool:
	return tile_type(pos) == 5

func is_level(pos: Vector2i) -> bool:
	return tile_type(pos) == 0
	
func is_black_hole(pos: Vector2i) -> bool:
	return tile_type(pos) == 6
