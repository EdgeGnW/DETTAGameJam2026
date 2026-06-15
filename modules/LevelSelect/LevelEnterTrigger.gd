class_name LevelEnterTrigger extends Area2D

@export var sceneToLoad: PackedScene
@export var text: String
@export var number: String
@export var label_below: bool
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var label: Label = $Label
signal isComplete

func _ready() -> void:
	position = tile_map_layer.map_to_local(tile_map_layer.local_to_map(position))
	label.text = number
	if not label_below:
		label.position.y = - (label.position.y + label.size.y)
	check_complete()
	#print(sceneToLoad)

func _on_area_entered(area: Area2D) -> void:
	if area is not Player:
		return
	var player = area as Player
	player.sceneToEnter = sceneToLoad
	label.text = text
	

func _on_area_exited(area: Area2D) -> void:
	if area is not Player:
		return
	(area as Player).sceneToEnter = null
	label.text = number

func check_complete():
	if not ProgressManager.isLevelCompleted(sceneToLoad):
		return
		
	var grid_position = tile_map_layer.local_to_map(position)
	tile_map_layer.set_cell(grid_position, 0, Vector2i(0, 2))
	
	isComplete.emit()
