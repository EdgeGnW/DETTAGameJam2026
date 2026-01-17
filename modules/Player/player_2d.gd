extends CharacterBody2D


@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var gravity: Vector2 = Vector2(0, 900)
@export var max_fall_speed: float = 1000
@export var height: float

var movement_locked := false
var dir: int

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var animal_state: AnimalState.Animal_state


func _physics_process(delta: float) -> void:
	if animal_state == AnimalState.Animal_state.RIDING:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta
		velocity.y = clamp(velocity.y, -1000, max_fall_speed)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = 0
	if animal_state == AnimalState.Animal_state.ACTIVE:
		direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		dir = int(direction)
	
	if movement_locked:
		move_and_slide()
		return
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func jump() -> void:
	velocity.y = jump_velocity

func set_animal_state(new_state: AnimalState.Animal_state) -> void:
	animal_state = new_state
	if animal_state == AnimalState.Animal_state.ACTIVE:
		$StateMachine.set_active(true)
	else:
		$StateMachine.set_active(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not movement_locked and is_on_floor() and animal_state == AnimalState.Animal_state.ACTIVE:
		jump()
