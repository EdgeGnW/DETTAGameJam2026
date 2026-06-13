extends Area2D

@export var sceneToLoad: PackedScene

func _on_area_entered(area: Area2D) -> void:
	SceneManager.update_current_scene(sceneToLoad)


func _on_body_entered(body: Node2D) -> void:
	print('body entered')
	SceneManager.update_current_scene(sceneToLoad)
