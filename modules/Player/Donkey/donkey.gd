extends CharacterBody2D


const SPEED: float = 300.0
const JUMP_VELOCITY: float = 0.0
const GRAVITY: Vector2 = Vector2(0, 900)
const MAX_FALL_SPEED: float = 1000

var movement_locked := false
var dir: int

@onready var sprite_2d: Sprite2D = %Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY * delta
		velocity.y = clamp(velocity.y, -1000, MAX_FALL_SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		dir = int(direction)
	
	if movement_locked:
		move_and_slide()
		return
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not movement_locked and is_on_floor():
		jump()
