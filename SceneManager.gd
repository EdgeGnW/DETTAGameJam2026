extends Node

var tutorial = load("res://modules/Test/Tutorial.tscn")

var current_scene = load("res://modules/Test/Tutorial.tscn")

func reset_progress() -> void:
	current_scene = tutorial

func update_current_scene(new_scene: PackedScene) -> void:
	current_scene = new_scene
