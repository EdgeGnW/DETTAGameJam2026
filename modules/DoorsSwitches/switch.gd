extends Area2D
class_name Switch

@export var door_index: int
@export var type: Type = Type.PLATE
var pressed = false
var active = true
signal updated()

var default_plate = load("res://modules/DoorsSwitches/Plate.png")
var pressed_plate = load("res://modules/DoorsSwitches/PlatePressed.png")
var default_lever = load("res://modules/DoorsSwitches/Lever.png")
var flipped_lever = load("res://modules/DoorsSwitches/LeverFlipped.png")
var final_plate = load("res://modules/DoorsSwitches/PlateFinal.png")

const FLICK_OFF = preload("uid://dyn16v41bjgvh")
const FLICK_ON = preload("uid://d0xlopomy2a3q")


enum Type {
	PLATE,
	LEVER
}

func _ready() -> void:
	if type == Type.PLATE:
		$Sprite.texture = default_plate
	else:
		$Sprite.texture = default_lever

func _on_body_entered(_body: Node2D) -> void:
	if type == Type.PLATE:
		if not pressed:
			pressed = true
			AudioManager.play_sound(FLICK_ON)
			$Sprite.texture = load("res://modules/DoorsSwitches/PlatePressed.png")
			updated.emit()
	else:
		$RichTextLabel.show()



func _on_body_exited(_body: Node2D) -> void:
	if type == Type.PLATE:
		if not pressed: return
		var bodies = get_overlapping_bodies()
		if len(bodies) < 1 and active:
			pressed = false
			AudioManager.play_sound(FLICK_OFF)
			$Sprite.texture = default_plate
			updated.emit()
	else:
		$RichTextLabel.hide()

func _input(event: InputEvent) -> void:
	if type == Type.LEVER and event.is_action_pressed("interact") and $RichTextLabel.visible:
		pressed = not pressed
		updated.emit()
		if pressed:
			$Sprite.texture = flipped_lever
		else:
			$Sprite.texture = default_lever

func press_permanently():
	if type == Type.PLATE:
		$Sprite.texture = final_plate
		active = false
		pressed = true
