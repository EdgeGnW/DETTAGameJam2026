extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = Vector2(get_parent().camera_zoom, get_parent().camera_zoom)
