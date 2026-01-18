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
			finish_step(2)
	elif step == 2:
		if rooster.global_position.x > 2550:
			$Step3.show()
		if rooster.animal_state == AnimalState.Animal_state.RIDING:
			finish_step(3)
	elif step == 3:
		if rooster.global_position.x > 3100:
			finish_step(4)
	elif step == 4:
		if rooster.global_position.x > 3550:
			$Step5.show()
		if rooster.global_position.x > 4100:
			finish_step(5)
	elif step == 5:
		if rooster.global_position.x > 4300:
			$Step6.show()
	elif step == 6:
		if rooster.global_position.x > 5200:
			$Step7.show()
		if rooster.global_position.y < -1500:
			finish_step(7)
	elif step == 7:
		if rooster.global_position.x < 5000:
			$Step8.show()
		if dog.animal_state == AnimalState.Animal_state.ACTIVE:
			finish_step(8)
	elif step == 8:
		if dog.animal_state == AnimalState.Animal_state.ACTIVE and cat.animal_state == AnimalState.Animal_state.RIDING:
			finish_step(9)
	elif step == 9:
		if rooster.global_position.x < 4000:
			$Step10.show()
		if dog.get_node("GrabArea").grabbed_body:
			finish_step(10)
	elif step == 10:
		if rooster.global_position.x < 2750:
			$Step11.show()
		if rooster.global_position.y < -1500 and 3000 < rooster.global_position.x and rooster.global_position.x < 3500:
			finish_step(11)
	elif step == 11:
		if not dog.get_node("GrabArea").grabbed_body:
			finish_step(12)
	elif step == 12:
		if rooster.global_position.x < 2800:
			$Step13.show()
		if rooster.global_position.x < 2050:
			finish_step(13)
	elif step == 13:
		if rooster.global_position.x < 1500:
			finish_step(14)
	elif step == 14:
		if rooster.global_position.x < 1000:
			$Step16.show()
		if $Switch5.pressed:
			finish_step(16)
	elif step == 16:
		if rooster.global_position.x < 1500 and rooster.global_position.y > -1500:
			finish_step(15)
	elif step == 15:
		if rooster.global_position.x < 1000:
			$Step17.show()
		


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("left"):
		pressed_left = true
	elif event.is_action("right"):
		pressed_right = true
	elif event.is_action("jump"):
		pressed_jump = true

	if pressed_left and pressed_right and pressed_jump and step == 0:
		finish_step(1)
	if step == 5 and event.is_action("dismount"):
		finish_step(6)

func finish_step(s: int):
	step = s
	get_node("Step" + str(s)).hide()
	if s == 1:
		for n in range(-12, -6):
			$TileMapLayer.set_cell(Vector2i(5, n))
		$TileMapLayer.set_cell(Vector2i(5, -6), 1, Vector2i(1, 0))
	elif s == 3:
		$Step4.show()
	elif s == 8:
		$Step9.show()
	elif s == 11:
		$Step12.show()
	elif s == 13:
		$Step14.show()
	
