extends Node2D

var pressed_left: bool = false
var pressed_right: bool = false
var pressed_jump: bool = false
var step: int = 0

@onready var rooster = $Rooster
@onready var cat = $Cat
@onready var dog = $Dog
@onready var donkey = $Donkey

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if step == 1:
		if rooster.global_position.x > 800:
			$Step2.show()
		if rooster.global_position.x > 1700:
			finish_step_2()
	elif step == 2:
		if rooster.global_position.x > 2550:
			$Step3.show()
		if rooster.animal_state == AnimalState.Animal_state.RIDING:
			finish_step_3()
	elif step == 3:
		if rooster.global_position.x > 3100:
			finish_step_4()
	elif step == 4:
		if rooster.global_position.x > 3550:
			$Step5.show()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("left"):
		pressed_left = true
	elif event.is_action("right"):
		pressed_right = true
	elif event.is_action("jump"):
		pressed_jump = true

	if pressed_left and pressed_right and pressed_jump and step == 0:
		finish_step_1()

func finish_step_1():
	step = 1
	$Step1.hide()
	for n in range(-12, -6):
		$TileMapLayer.set_cell(Vector2i(5, n))
	$TileMapLayer.set_cell(Vector2i(5, -6), 1, Vector2i(1, 0))


func finish_step_2():
	step = 2
	$Step2.hide()

func finish_step_3():
	step = 3
	$Step3.hide()
	$Step4.show()

func finish_step_4():
	step = 4
	$Step4.hide()
	
