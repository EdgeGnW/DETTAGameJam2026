extends HSlider

@export var audio_bus_name: String
var audio_bus_index: int

const SFX_TEST := preload("res://main_menu/test.wav")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio_bus_index = AudioServer.get_bus_index(audio_bus_name)



func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(audio_bus_index, value / 100)
	print(value)
	AudioManager.play_sound(SFX_TEST)
