class_name Player3D
extends CharacterBody3D

@onready var hand = %Hand
@onready var camera = $Camera3D

@export_range(-90, 0, 0.01, "radians_as_degrees") var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export_range(0, 90, 0.01, "radians_as_degrees") var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var MOUSE_SENSETIVITY := 0.002

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var rot_x = 0
var rot_y = 0

var inventory: Inventory = Inventory.new()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * MOUSE_SENSETIVITY
		rot_y += event.relative.y * MOUSE_SENSETIVITY
		rot_y = clamp(rot_y, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
		camera.transform.basis = Basis() # reset rotation
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, -1, 0), rot_x) # first rotate in Y
		camera.rotate_object_local(Vector3(-1, 0, 0), rot_y) # then rotate in X
	elif event.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func on_item_picked_up(item: Item):
	inventory.add_item(item)
