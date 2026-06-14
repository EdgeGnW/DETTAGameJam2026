extends Control

@onready var options: PanelContainer = $Options
@onready var menu: PanelContainer = $Menu
@onready var controls: PanelContainer = $Controls
@onready var level_complete: PanelContainer = $LevelComplete
@onready var game_over: PanelContainer = $GameOver

signal undo_last_move


func _on_leave_pressed() -> void:
	level_complete.hide()
	game_over.hide()
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

func _on_level_complete() -> void:
	await get_tree().create_timer(2).timeout
	level_complete.show()
	ProgressManager.completeLevel(SceneManager.current_scene.resource_path.split('/')[-1])
	ProgressManager.saveProgress()
	
func _on_game_over():
	game_over.show()

func _on_restart_level_pressed() -> void:
	game_over.hide()
	SceneManager.reload_current_scene()

func _on_undo_last_move_pressed() -> void:
	game_over.hide()
	undo_last_move.emit()
