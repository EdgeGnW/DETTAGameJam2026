extends Area2D

@export var next_level: PackedScene


func _on_body_entered(body: Node2D) -> void:
	var animals_in_range = get_overlapping_bodies()
	if animals_in_range.size() == 4:
		for animal in animals_in_range:
			animal.animal_state = AnimalState.Animal_state.RIDING
		$LightsOff.hide()
		$LightsOn.show()
		var tween = get_tree().create_tween()
		var camera = get_viewport().get_camera_2d()
		tween.tween_property(camera, "zoom", Vector2(4,4), 2.0).set_trans(Tween.TRANS_CUBIC)
		$CanvasLayer.show()
		SceneManager.current_scene = next_level


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_level)


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().free()
