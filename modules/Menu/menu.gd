extends Control

@onready var options: PanelContainer = $Options
@onready var menu: PanelContainer = $Menu
@onready var controls: PanelContainer = $Controls


func _on_leave_pressed() -> void:
	SceneManager.go_back()


func _on_options_pressed() -> void:
	options.show()
	#menu.hide()


func _on_hide_options_pressed() -> void:
	options.hide()
	menu.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		menu.visible = not menu.visible
		
	if not menu.visible:
		options.hide()
		controls.hide()


func _on_controls_pressed() -> void:
	controls.show()


func _on_hide_controls_pressed() -> void:
	controls.hide()


func _on_music_value_changed(value: float) -> void:
	AudioManager.set_volume("Music", value)


func _on_sound_value_changed(value: float) -> void:
	AudioManager.set_volume("SoundEffects", value)


func _on_ambient_value_changed(value: float) -> void:
	AudioManager.set_volume("Ambience", value)
