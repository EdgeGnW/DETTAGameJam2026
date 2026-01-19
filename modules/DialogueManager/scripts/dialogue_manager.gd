extends CanvasLayer

class DialogueLine:
	var character: String
	var text: String
	
	func _init(c: String = "", t: String = "") -> void:
		character = c
		text = t

enum DialogueState {
	Disabled,
	Reading,
	Done
}

signal finished()

var text_sound = preload("res://modules/DialogueManager/sfx/default.wav")

var state = DialogueState.Disabled

var text_tween: Tween

var visible_characters = 0

#@export_multiline var dialogue_string: String
#@export_file("*.txt") var dialogue_file: String
@export var characters_per_second : float = 12
@export var characters: Dictionary[String, Character]
@export var default_character: Character = Character.new("", null, text_sound)

var dialogue: Array[DialogueLine] = []

var current_character: Character

func _physics_process(_delta: float) -> void:
	if state != DialogueState.Reading or %DialogueText.visible_characters == 0: return
	if visible_characters == %DialogueText.visible_characters:
		return
	visible_characters = %DialogueText.visible_characters
	var current_char_index: int = %DialogueText.visible_characters - 1
	if current_char_index < 0:
		current_char_index = len(%DialogueText.text) - 1
	var current_char: String = %DialogueText.text[current_char_index]
	if current_char in [" ", "."]:
		var pause = 0.003
		if current_char == ".": pause = 0.4
		text_tween.pause()
		await get_tree().create_timer(pause).timeout
		if text_tween.is_valid(): text_tween.play()
		return
	var pitch_scale = randf_range(0.9, 1.1)
	if current_char in ["a", "i", "u", "e", "o"]:
		pitch_scale += 0.2
	elif current_char in ["!", "m", "n", "g"]:
		pitch_scale -= 0.2
	elif current_char == "?":
		pitch_scale = 1.2
	var voice = current_character.voice
	AudioManager.play_sound(voice, pitch_scale)

func change_state(new_state: DialogueState):
	#print("changing from: " + State.keys()[state] + " to: " + State.keys()[new_state])
	#$Label.text = State.keys()[new_state]
	if text_tween:
		text_tween.kill()
	match new_state:
		DialogueState.Disabled:
			hide()
			process_mode = Node.PROCESS_MODE_DISABLED
			fade_out($MarginContainer, 1)
			fade_out($MarginContainer2, 1)
		DialogueState.Reading:
			visible_characters = 0
			process_mode = Node.PROCESS_MODE_PAUSABLE
			var tween_ratio = len(%DialogueText.text) / characters_per_second
			text_tween = create_tween()
			%DialogueText.visible_ratio = 0
			text_tween.tween_property(%DialogueText, "visible_ratio", 1, tween_ratio)
			text_tween.tween_callback(start_cooldown)
			show()
			fade_in($MarginContainer, 1)
			fade_in($MarginContainer2, 1)
		DialogueState.Done:
			process_mode = Node.PROCESS_MODE_PAUSABLE
			%DialogueText.visible_ratio = 1
			show()
	state = new_state

func _ready() -> void:
	change_state(DialogueState.Disabled)
	#if dialogue_file:
	#	add_dialogue_file(dialogue_file)
	#elif dialogue_string:
	#	add_dialogue_string(dialogue_string)

func _add_dialogue_line(line: DialogueLine):
	dialogue.push_back(line)
	if state == DialogueState.Disabled:
		next_line()
		change_state(DialogueState.Reading)

func _add_dialogue_line_array(lines: Array[DialogueLine]):
	dialogue.append_array(lines)
	if state == DialogueState.Disabled:
		next_line()
		change_state(DialogueState.Reading)

# A DiaglogueString is a String in the format "CHARACTER_A: TEXT\nCHARACTER_B: TEXT..."
func add_dialogue_string(dialogue_string: String):
	var lines := dialogue_string.split("\n", false)
	for line in lines:
		var parts := line.split(":", true, 1)
		var character := ""
		var text := ""
		if len(parts) < 2:
			text = line.strip_edges()
		else:
			character = parts[0].strip_edges()
			text = parts[1].strip_edges()
			assert(character, ": without character")
		dialogue.push_back(DialogueLine.new(character, text))
	if state == DialogueState.Disabled:
		next_line()
		change_state(DialogueState.Reading)
		
func add_dialogue_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	add_dialogue_string(content)


func next_line():
	if not dialogue:
		change_state(DialogueState.Disabled)
		finished.emit()
		return
	var line: DialogueLine = dialogue.pop_front()
	current_character = characters.get(line.character, default_character)
	
	
	%Portrait.texture = current_character.picture
	%CharacterName.text = current_character.name
	%DialogueText.text = line.text
	change_state(DialogueState.Reading)
	
func start_cooldown():
	%ReadCooldown.start()
	
func skip_line():
	%ReadCooldown.stop()
	change_state(DialogueState.Done)
	
func is_active():
	return state != DialogueState.Disabled

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match state:
			DialogueState.Reading:
				skip_line()
			DialogueState.Done:
				next_line()
		get_viewport().set_input_as_handled()

func fade_in(node: Node, duration: float) -> void:
	node.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 1, duration) 
	tween.play()
	
func fade_out(node: Node, duration: float) -> void:
	node.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 0, duration) 
	tween.play()
