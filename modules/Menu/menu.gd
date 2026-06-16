extends Control

@onready var options: PanelContainer = $Options
@onready var menu: PanelContainer = $Menu
@onready var controls: PanelContainer = $Controls
@onready var level_complete: PanelContainer = $LevelComplete
@onready var game_over: PanelContainer = $GameOver

signal undo_last_move


func _on_leave_pressed() -> void:
	ProgressManager.saveProgress()
	get_tree().quit()


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
	if controls.visible and not menu.visible:
		controls.hide()
	else:
		menu.visible = not menu.visible
		get_tree().paused = not get_tree().paused
				
		if not menu.visible:
			options.hide()
			controls.hide()
		else:
			menu.get_child(0).get_child(0).grab_focus()
			if Globals.menu_position_stack.size() > 0:
				menu.find_child("Hub").show()
			else:
				menu.find_child("Hub").hide()
			if Globals.menu_position_stack.size() > 1:
				menu.find_child("Starmap").show()
			else:
				menu.find_child("Starmap").hide()
			

func _on_controls_pressed() -> void:
	controls.show()
	controls.get_child(0).get_child(2).grab_focus()


func _on_hide_controls_pressed() -> void:
	controls.hide()
	if not menu.visible:
		get_tree().paused = not get_tree().paused
	else:
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


func _on_starmap_pressed() -> void:
	level_complete.hide()
	game_over.hide()
	SceneManager.go_back()
	toggle_menu()


func _on_hub_pressed() -> void:
	level_complete.hide()
	game_over.hide()
	while Globals.menu_position_stack.size() > 0:
		await SceneManager.go_back()
	toggle_menu()


func _on_keyboard_pressed() -> void:
	controls.find_child("Label").text = "Menüführung
	   Menü aufrufen - Escape
	   Button wechseln - WASD / Tab
	   Button drücken - Leertaste / Enter
	
	Bewegung von Uriel
	   Richtung wechseln - WEDXYA
	   Richtung bestätigen - Leertaste
	   Richtung lösen - S
	   Zug ausführen / Farbe wechseln / Level betreten - Enter
	   (Farbe wechseln - Tab)
	
	Sonstiges
	   Schritt rückgängig - K
	   Level neustarten - L"


func _on_mouse_pressed() -> void:
	controls.find_child("Label").text = "Menüführung
	   Menü aufrufen - <>
	   Button wechseln - Mausbewegung
	   Button drücken - Linke Maustaste
	
	Bewegung von Uriel
	   Richtung wechseln - Mausbewegung
	   Richtung bestätigen - Linke Maustaste
	   Richtung lösen - Mittlere Maustaste
	   Zug ausführen / Farbe wechseln / Level betreten - Rechte Maustaste
	   (Farbe wechseln - Mausrad)
	
	Sonstiges
	   Schritt rückgängig - Mittlere Maustaste (Mausrad)
	   Level neustarten - <>"


func _on_controller_pressed() -> void:
	controls.find_child("Label").text = "Menüführung
	   Menü aufrufen - Menu Button
	   Button wechseln - Joystick
	   Button drücken - A
	
	Bewegung von Uriel
	   Richtung wechseln - Joystick
	   Richtung bestätigen - X
	   Richtung lösen - L3 (Linker Stick)
	   Zug ausführen / Farbe wechseln / Level betreten - A
	   (Farbe wechseln - Schultertasten)
	
	Sonstiges
	   Schritt rückgängig - B
	   Level neustarten - Y"


func _on_mouse_keyboard_pressed() -> void:
	controls.find_child("Label").text = "Menüführung
	   Menü aufrufen - Escape
	   Button wechseln - Mausbewegung
	   Button drücken - Linke Maustaste / Enter
	
	Bewegung von Uriel
	   Richtung wechseln - Mausbewegung
	   Richtung bestätigen - Linke Maustaste
	   Richtung lösen - Mittlere Maustaste
	   Zug ausführen / Farbe wechseln / Level betreten - Rechte Maustaste / Enter
	   Farbe wechseln - Tab
	
	Sonstiges
	   Schritt rückgängig - K
	   Level neustarten - L"


func _on_level_complete_pressed() -> void:
	level_complete.hide()
	game_over.hide()
	if Globals.menu_position_stack.size() > 0:
		SceneManager.go_back()
	
