extends Camera2D

var background: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = Vector2(get_parent().camera_zoom, get_parent().camera_zoom)
	background = $CanvasLayer/Background

func _process(delta: float) -> void:
	background.global_position.x = 1920 - int(round(global_position.x / 2)) % 1920
	background.global_position.y = clamp(-global_position.y / 1.3, 0, 1080)
