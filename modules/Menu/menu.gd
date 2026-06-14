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
	options.get_child(0).get_child(2).grab_focus()


func _on_hide_options_pressed() -> void:
	options.hide()
	menu.show()
	menu.get_child(0).get_child(1).grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		toggle_menu()
			
		
func toggle_menu():
	menu.visible = not menu.visible
			
	if not menu.visible:
		options.hide()
		controls.hide()
	else:
		menu.get_child(0).get_child(0).grab_focus()

func _on_controls_pressed() -> void:
	controls.show()
	controls.get_child(0).get_child(2).grab_focus()


func _on_hide_controls_pressed() -> void:
	controls.hide()
	menu.get_child(0).get_child(0).grab_focus()


func _on_music_value_changed(value: float) -> void:
	AudioManager.set_volume("Music", value)


func _on_sound_value_changed(value: float) -> void:
	AudioManager.set_volume("SoundEffects", value)


func _on_ambient_value_changed(value: float) -> void:
	AudioManager.set_volume("Ambience", value)

func _on_level_complete() -> void:
	await get_tree().create_timer(2).timeout
	level_complete.show()
	level_complete.get_child(0).get_child(1).grab_focus()
	ProgressManager.completeLevel(SceneManager.current_scene)
	ProgressManager.saveProgress()
	
func _on_game_over():
	game_over.show()
	game_over.get_child(0).get_child(1).grab_focus()

func _on_restart_level_pressed() -> void:
	game_over.hide()
	SceneManager.reload_current_scene()

func _on_undo_last_move_pressed() -> void:
	game_over.hide()
	undo_last_move.emit()

func getSceneName(scene: PackedScene) -> String:
	return scene.resource_path.split('/')[-1]


func _on_reset_progress_pressed() -> void:
	ProgressManager.resetProgress()


func _on_back_pressed() -> void:
	toggle_menu()
