extends Control

const MAIN_MENU = preload("uid://busdhk8ltwy51")


func _ready():
	DialogueManager.add_dialogue_file("res://main_menu/Enddialogue.txt")
	await DialogueManager.finished
	get_tree().change_scene_to_packed(MAIN_MENU)
	
