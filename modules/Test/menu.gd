extends CanvasLayer

var zoom = 6

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if visible:
			deactivate()
		else:
			get_tree().paused = true
			show()


func deactivate():
	hide()
	get_tree().paused = false


func _on_button_pressed() -> void:
	deactivate()


func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().free()
