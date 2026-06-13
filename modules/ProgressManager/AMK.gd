extends Node

func _on_save() -> void:
	ProgressManager.saveProgress()

func _on_load() -> void:
	ProgressManager.loadProgress()

func _on_add() -> void:
	var level: String = str(RandomNumberGenerator.new().randf())
	ProgressManager.completeLevel(level)
