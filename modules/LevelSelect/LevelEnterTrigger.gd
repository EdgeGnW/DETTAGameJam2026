class_name LevelEnterTrigger extends Area2D

@export var sceneToLoad: PackedScene
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
signal isComplete

func _ready() -> void:
	position = tile_map_layer.map_to_local(tile_map_layer.local_to_map(position))
	check_complete()
	#print(sceneToLoad)

func _on_area_entered(area: Area2D) -> void:
	if area is not Player:
		return
	(area as Player).sceneToEnter = sceneToLoad

func _on_area_exited(area: Area2D) -> void:
	if area is not Player:
		return
	(area as Player).sceneToEnter = null

func check_complete():
	if not ProgressManager.isLevelCompleted(sceneToLoad):
		return
		
	var grid_position = tile_map_layer.local_to_map(position)
	tile_map_layer.set_cell(grid_position, 0, Vector2i(0, 2))
	
	isComplete.emit()
