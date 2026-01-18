extends Control

func _ready():
	DialogueManager.add_dialogue_file("res://main_menu/Enddialogue.txt")
	
func _physics_process(_delta: float) -> void:
	if DialogueManager.state == DialogueManager.DialogueState.Disabled:
		get_tree().quit()
