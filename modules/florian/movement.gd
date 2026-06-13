extends TileMapLayer

@export var speed: float

@onready var red: Node2D = $Red
@onready var orange: Node2D = $Orange
@onready var white: Node2D = $White

@onready var yellow: Node2D = $Yellow
@onready var green: Node2D = $Green

@onready var blue: Node2D = $Blue
@onready var violet: Node2D = $Violet

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
	move(Vector3i(0, 0, 0))

func update_colors():
	red.visible = false
	yellow.visible = false
	blue.visible = false
	orange.visible = false
	green.visible = false
	violet.visible = false
	white.visible = false
	if red_pos == yellow_pos:
		if red_pos == blue_pos:
			white.visible = true
		else:
			orange.visible = true
			blue.visible = true
	elif red_pos == blue_pos:
		violet.visible = true
		yellow.visible = true
	elif yellow_pos == blue_pos:
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
	if direction == 0:
		next_tile = Vector2i(source.x+1, source.y)
	elif direction == 1:
		next_tile = Vector2i(source.x+(1 if source.y%2 == 1 else 0), source.y+1)
	elif direction == 2:
		next_tile = Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y+1)
	elif direction == 3:
		next_tile = Vector2i(source.x-1, source.y)
	elif direction == 4:
		next_tile = Vector2i(source.x-(1 if source.y%2 == 0 else 0), source.y-1)
	else:
		next_tile = Vector2i(source.x+(1 if source.y%2 == 1 else 0), source.y-1)
		
	if is_wall(next_tile) or path_length > 500:
		print("Hit wall", next_tile)
		return path
	
	if is_mirror(next_tile):
		direction = reflect(next_tile, direction, color)
		if direction == -1:
			return path
	elif is_prism(next_tile):
		direction = (direction + 5 + color)%6
	
	return path + compute_movement_path(next_tile, direction, color, path_length + 1)


func is_wall(position: Vector2i) -> bool:
	# TODO: Only for testing purposes
	return position.x < 0 or position.x > 50 or position.y < 0 or position.y > 30 or tyle_type(position) == 1 #or grid[position.x][position.y] == 1

func is_mirror(position: Vector2i) -> bool:
	# TODO: Only for testing purposes
	return grid[position.x][position.y] > 1 and grid[position.x][position.y] < 20
	
func is_prism(position: Vector2i) -> bool:
	# TODO: Only for testing purposes
	return grid[position.x][position.y] == 20

func reflect(position: Vector2i, direction: int, color: int) -> int:
	var mirror_type = grid[position.x][position.y] - 2 # Value between 0 - 17
	var double_sided = mirror_type < 6
	var new_direction = 9 - direction + (mirror_type % 6)
	if new_direction == direction:
		print("Hit mirror's edge")
		return -1
	# TODO: Only out due to testing purposes
	#elif (not double_sided and abs(direction - (mirror_type-6)/2) in [0, 1, 5]):
	#	print("Hit mirror's backside")
	#	return -1
	return new_direction

func tyle_type(position: Vector2i) -> int:
	if get_cell_tile_data(position):
		return get_cell_source_id(position)
	return 0;

func move(directions: Vector3i):
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
		
		if red_path.is_empty() and yellow_path.is_empty() and blue_path.is_empty():
			moving = false
			
			await get_tree().create_timer(2).timeout
			var dir = randi() % 6
			move(Vector3i(dir, dir, dir))
