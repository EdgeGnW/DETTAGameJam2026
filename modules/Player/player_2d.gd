class_name Player2D
extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_height: float = 40.0
@export var max_fall_speed: float = 1000
@export var height: float
@export var camera_zoom: float = 1.0
var gravity: Vector2 = Vector2(0, 1000)
const MAX_VELOCITY: float = 80
var free_falling: bool = false

var movement_locked := false
var dir: int

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var animal_state: AnimalState.Animal_state
var has_mount: bool = false
var mount: Player2D

func _physics_process(delta: float) -> void:
	if animal_state == AnimalState.Animal_state.RIDING:
		return
	# Add the gravity
	if not is_on_floor(): 
		velocity += gravity * delta
		var upper_limit = max_fall_speed
		if free_falling:
			upper_limit = 1000
		velocity.y = clamp(velocity.y, -1000, upper_limit)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = 0
	if animal_state == AnimalState.Animal_state.ACTIVE:
		direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		dir = int(direction)
		var flip_h = dir < 0
		if sprite_2d.flip_h != flip_h:
			flip_mount()
		sprite_2d.flip_h = flip_h
		
		
	
	if movement_locked:
		move_and_slide()
		return
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i)
		var collision = collider.get_collider()
		if collision.is_in_group("movables") and name == "Donkey" and abs(collision.get_linear_velocity().x) < MAX_VELOCITY:
			collision.apply_central_impulse(collider.get_normal() * -speed)
	
func jump() -> void:
	velocity.y = -sqrt(1000 * jump_height)

func set_animal_state(new_state: AnimalState.Animal_state) -> void:
	animal_state = new_state
	if animal_state == AnimalState.Animal_state.ACTIVE:
		$StateMachine.set_active(true)
		get_viewport().get_camera_2d().zoom = Vector2(camera_zoom, camera_zoom)
	else:
		$StateMachine.set_active(false)

func dismount(jump_start: bool) -> void:
	var mounter = $Mount.get_child(1)
	$Mount.remove_child(mounter)
	get_parent().add_child(mounter)
	animal_state = AnimalState.Animal_state.ALONE
	mounter.set_animal_state(AnimalState.Animal_state.ACTIVE)
	mounter.global_position = get_child(3).global_position
	if jump_start:
		mounter.jump()
	await get_tree().create_timer(1).timeout
	has_mount = false
	mount = null


func _unhandled_input(event: InputEvent) -> void:
	if animal_state == AnimalState.Animal_state.ACTIVE:
		if event.is_action_pressed("ui_accept"):
			if Input.is_action_pressed("ui_down") and has_mount:
				dismount(false)
			elif Input.is_action_pressed("ui_up") and has_mount:
				free_falling = false
				dismount(true)
			elif not movement_locked and is_on_floor():
				free_falling = false
				jump()
		elif event.is_action_released("ui_accept"):
			if velocity.y < 0:
				velocity.y *= 0.5
		elif event.is_action_pressed("ui_down"):
			free_falling = true
		elif event.is_action_released("ui_down"):
			free_falling = false
				
func flip_mount():
	if not has_mount: return
	mount.sprite_2d.flip_h = !mount.sprite_2d.flip_h
	mount.flip_mount()
	
