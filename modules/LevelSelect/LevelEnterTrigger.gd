extends Area2D

@export var sceneToLoad: PackedScene
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

func _ready() -> void:
	position = tile_map_layer.map_to_local(tile_map_layer.local_to_map(position))
	print(sceneToLoad)

func _on_area_entered(area: Area2D) -> void:
	if area is not Player:
		return
	(area as Player).sceneToEnter = sceneToLoad


func _on_area_exited(area: Area2D) -> void:
	if area is not Player:
		return
	(area as Player).sceneToEnter = null
