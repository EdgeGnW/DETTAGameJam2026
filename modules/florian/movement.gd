extends TileMapLayer

@export var speed: float

@onready var inputManager = %InputManager

@onready var red: Player = $"../Red"
@onready var blue: Player = $"../Blue"
@onready var yellow: Player = $"../Yellow"
@onready var green: Player = $"../Green"
@onready var violet: Player = $"../Violet"
@onready var white: Player = $"../White"
@onready var orange: Player = $"../Orange"


@export var red_pos: Vector2i
@export var yellow_pos: Vector2i
@export var blue_pos: Vector2i

var red_path: Array[Vector2i]
var yellow_path: Array[Vector2i]
var blue_path: Array[Vector2i]

var RED = 0
var YELLOW = 1
var BLUE = 2

var moving: bool

var wrongDirectionsDict = {
	HexagonalInput.Direction.Right: 0,
	HexagonalInput.Direction.DownRight: 1,
	HexagonalInput.Direction.DownLeft: 2,
	HexagonalInput.Direction.Left: 3,
	HexagonalInput.Direction.UpLeft: 4,
	HexagonalInput.Direction.UpRight: 5,
}


# TODO: Just for testing purposes
var grid: Array[Array]

func _ready() -> void:
	red.position = map_to_local(red_pos)
	yellow.position = map_to_local(yellow_pos)
	blue.position = map_to_local(blue_pos)
	orange.position = map_to_local(red_pos)
	green.position = map_to_local(yellow_pos)
	violet.position = map_to_local(blue_pos)
	white.position = map_to_local(red_pos)
	red_path = []
	yellow_path = []
	blue_path = []
	moving = false
	update_colors()
	
	# TODO: Just for testing purposes - Creating grid (should be read from the tilemap)
	grid.append([])
	for j in range(32):
		grid[-1].append(0)
	grid[-1].append(1)
	for i in range(50):
		grid.append([])
		grid[-1].append(0)
		for j in range(30):
			if get_cell_tile_data(Vector2i(i,j)):
				if (get_cell_source_id(Vector2i(i,j))==1):
					grid[-1].append(1)
				elif (get_cell_source_id(Vector2i(i,j))==2):
					grid[-1].append(randi() % 19 + 2)
				print("Tile: ", Vector2i(i,j), get_cell_source_id(Vector2i(i,j)))
			else:
				grid[-1].append(0)
		grid[-1].append(0)
		grid[-1].append(1)
	grid.append([])
	for j in range(32):
		grid[-1].append(0)
	grid[-1].append(1)
	grid.append([])
	for j in range(33):
		grid[-1].append(1)
	await get_tree().create_timer(2).timeout
	#move(Vector3i(0, 0, 0))
	
	inputManager.reactToInput(true)
	var newDirection = await inputManager.selectedDirection
	var wrongDirection = wrongDirectionsDict.get(newDirection)
	
	inputManager.reactToInput(false)
	move_in_directions(Vector3i(wrongDirection, wrongDirection, wrongDirection))

func update_colors():
	red.visible = false
	yellow.visible = false
	blue.visible = false
	orange.visible = false
	green.visible = false
	violet.visible = false
	white.visible = false
	if red.position.distance_to(yellow.position) < 0.1:
		if red.position.distance_to(blue.position) < 0.1:
			white.visible = true
		else:
			orange.visible = true
			blue.visible = true
	elif red.position.distance_to(blue.position) < 0.1:
		violet.visible = true
		yellow.visible = true
	elif yellow.position.distance_to(blue.position) < 0.1:
		green.visible = true
		red.visible = true
	else:
		red.visible = true
		yellow.visible = true
		blue.visible = true

func compute_movement_path(source: Vector2i, direction: int, color: int, path_length: int = 0) -> Array[Vector2i]:
	# direction: 0 -> right, 1 -> right below, 2 -> left below, 3 -> left, 4 -> left above, 5 -> right above
	var path: Array[Vector2i] = [source]
	
	var next_tile = Vector2i(source)
	if direction == Globals.Direction.Right:
		next_tile = Vector2i(source.x+1, source.y)
	elif direction == Globals.Direction.UpRight:
		next_tile = Vector2i(source.x+(1 if source.y%2 == 1 else 0), source.y+1)
	elif direction == Globals.Direction.UpLeft:
		next_tile = Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y+1)
	elif direction == Globals.Direction.Left:
		next_tile = Vector2i(source.x-1, source.y)
	elif direction == Globals.Direction.DownLeft:
		next_tile = Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y-1)
	else:
		next_tile = Vector2i(source.x+(1 if source.y%2 == 1 else 0), source.y-1)
		
	if is_wall(next_tile) or path_length > 500:
		print("Hit wall")
		return path
	
	if is_mirror(next_tile):
		print("Hit mirror")
		direction = reflect(next_tile, direction, color)
		if direction == -1:
			return path
	elif is_prism(next_tile):
		direction = (direction + 5 + color)%6
	
	return path + compute_movement_path(next_tile, direction, color, path_length + 1)


func is_wall(position: Vector2i) -> bool:
	return tile_type(position) == 1

func is_mirror(position: Vector2i) -> bool:
	return tile_type(position) == 2
	
func is_prism(position: Vector2i) -> bool:
	return tile_type(position) == 3

func reflect(position: Vector2i, direction: int, color: int) -> int:
	var mirror_type = get_cell_atlas_coords(position) # Value between 0 - 17
	var double_sided = mirror_type.y == 0
	var new_direction = (9 - direction + mirror_type.x) % 6
	if new_direction == direction:
		print("Hit mirror's edge")
		return -1
	elif (not double_sided and abs(direction - mirror_type.y + 1) in [0, 1, 5]):
		print("Hit mirror's backside")
		return -1
	return new_direction

func tile_type(position: Vector2i) -> int:
	if get_cell_tile_data(position):
		return get_cell_source_id(position)
	return 0;

func move_in_directions(directions: Vector3i):
	red_path = compute_movement_path(local_to_map(red.position), directions.x, RED)
	yellow_path = compute_movement_path(local_to_map(yellow.position), directions.y, YELLOW)
	blue_path = compute_movement_path(local_to_map(blue.position), directions.z, BLUE)
	red_pos = red_path.pop_front()
	yellow_pos = yellow_path.pop_front()
	blue_pos = blue_path.pop_front()
	moving = true


func _move_red(move: Vector2):
	red.position += move
	orange.position += move
	white.position += move


func _move_yellow(move: Vector2):
	yellow.position += move
	green.position += move


func _move_blue(move: Vector2):
	blue.position += move
	violet.position += move


func _process(delta: float) -> void:
	if moving:
		var red_local_pos = map_to_local(red_pos)
		var red_move = red_local_pos - red.position
		if red_move.length() <= delta*speed and not red_path.is_empty():
			red_pos = red_path.pop_front()
			var next_move = map_to_local(red_pos) - red_local_pos
			next_move *= (delta*speed - red_move.length()) / next_move.length()
			red_move += next_move
		elif red_move.length() > delta*speed:
			red_move *= delta*speed / red_move.length()
		_move_red(red_move)
		
		var yellow_local_pos = map_to_local(yellow_pos)
		var yellow_move = yellow_local_pos - yellow.position
		if yellow_move.length() <= delta*speed and not yellow_path.is_empty():
			yellow_pos = yellow_path.pop_front()
			var next_move = map_to_local(yellow_pos) - yellow_local_pos
			next_move *= (delta*speed - yellow_move.length()) / next_move.length()
			yellow_move += next_move
		elif yellow_move.length() > delta*speed:
			yellow_move *= delta*speed / yellow_move.length()
		_move_yellow(yellow_move)
		
		var blue_local_pos = map_to_local(blue_pos)
		var blue_move = blue_local_pos - blue.position
		if blue_move.length() <= delta*speed and not blue_path.is_empty():
			blue_pos = blue_path.pop_front()
			var next_move = map_to_local(blue_pos) - blue_local_pos
			next_move *= (delta*speed - blue_move.length()) / next_move.length()
			blue_move += next_move
		elif blue_move.length() > delta*speed:
			blue_move *= delta*speed / blue_move.length()
		_move_blue(blue_move)
		
		update_colors()
		
		if red_move.length() + yellow_move.length() + blue_move.length() == 0 and red_path.is_empty() and yellow_path.is_empty() and blue_path.is_empty():
			moving = false
			
			# TODO: Only for testing purposes
			#await get_tree().create_timer(2).timeout
			#var dir = randi() % 6
			#move(Vector3i(dir, dir, dir))
			
			inputManager.reactToInput(true)
			var newDirection = await inputManager.selectedDirection
			var wrongDirection = wrongDirectionsDict.get(newDirection)
			
			inputManager.reactToInput(false)
			move_in_directions(Vector3i(wrongDirection, wrongDirection, wrongDirection))
			
