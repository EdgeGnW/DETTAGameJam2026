extends Area2D

enum Type {
	Enter,
	Interact,
}

@export var type: Type = Type.Enter
@export_multiline var dialogue_text: String
@export_file("*.txt") var dialogue_file: String

func _ready() -> void:
	if not (dialogue_text or dialogue_file):
		assert(false, "No Dialogue String or File specified")
		
	match type:
		Type.Interact:
			set_process_input(true)
		_:
			set_process_input(false)
			
		
func _display_text():
	if dialogue_file:
		DialogueManager.add_dialogue_file(dialogue_file)
	else:
		DialogueManager.add_dialogue_string(dialogue_text)

# make sure player has own collision layer
func _on_body_entered(_body: Node2D) -> void:
	match type:
		Type.Enter:
			_display_text()
			queue_free()
		_:
			$RichTextLabel.show()

func _on_body_exited(_body: Node2D) -> void:
	$RichTextLabel.hide()
	
func _input(event: InputEvent) -> void:
	if DialogueManager.state != DialogueManager.DialogueState.Disabled: return
	if type == Type.Interact and event.is_action_pressed("ui_accept") and $RichTextLabel.visible:
		_display_text()
		get_viewport().set_input_as_handled()
