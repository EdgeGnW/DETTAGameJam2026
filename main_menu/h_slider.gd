extends HSlider

@export var audio_bus_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# var audio_bus_id = AudioServer.get_bus_index()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_value_changed(value: float) -> void:
	print(value)
