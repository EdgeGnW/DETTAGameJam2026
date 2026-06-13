extends Node

#var tutorial = load("res://modules/Test/Tutorial.tscn")

var current_scene = null # load("res://modules/Test/Tutorial.tscn")

var scene_stack: Array[PackedScene] = []
#func reset_progress() -> void:
	#current_scene = tutorial

func update_current_scene(new_scene: PackedScene) -> void:
	scene_stack.push_back(current_scene)
	current_scene = new_scene
	get_tree().change_scene_to_packed(current_scene)
	
func go_back():
	if not scene_stack:
		ProgressManager.saveProgress()
		get_tree().quit()
	current_scene = scene_stack.pop_back()
	get_tree().change_scene_to_packed(current_scene)
