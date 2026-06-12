extends TileMapLayer

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

var RED = 0
var YELLOW = 1
var BLUE = 2

func _ready() -> void:
	red.position = map_to_local(red_pos)
	yellow.position = map_to_local(yellow_pos)
	blue.position = map_to_local(blue_pos)
	orange.position = map_to_local(red_pos)
	green.position = map_to_local(yellow_pos)
	violet.position = map_to_local(blue_pos)
	white.position = map_to_local(red_pos)
	update_colors()

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

func compute_movement_path(source: Vector2i, direction: int, color: int):
	# direction: 0 -> right, 1 -> right below, 2 -> left below, 3 -> left, 4 -> left above, 5 -> right above
	var path = [source]
	
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
		
	if is_wall(next_tile):
		return path
	
	if is_mirror(next_tile):
		direction = reflect(next_tile, direction, color)
	elif is_prism(next_tile):
		direction = (direction + 2 + color)%6
	
	return path + compute_movement_path(next_tile, direction, color)


func is_wall(position: Vector2i) -> bool:
	return position.x < 0 or position.x > 10 or position.y < 0 or position.y > 10

func is_mirror(position: Vector2i) -> bool:
	return false
	
func is_prism(position: Vector2i) -> bool:
	return false

func reflect(position: Vector2i, direction: int, color: int) -> int:
	return 0


func move(directions: Vector3i):
	var red_path = compute_movement_path(local_to_map(red.position), directions.x, RED)
	var yellow_path = compute_movement_path(local_to_map(yellow.position), directions.y, YELLOW)
	var blue_path = compute_movement_path(local_to_map(blue.position), directions.z, BLUE)
	


func _process(delta: float) -> void:
	pass
