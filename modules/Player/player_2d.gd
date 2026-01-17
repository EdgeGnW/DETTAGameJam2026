class_name Player2D
extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var gravity: Vector2 = Vector2(0, 900)
@export var max_fall_speed: float = 1000
@export var height: float
@export var camera_zoom: float = 1.0
const MAX_VELOCITY: float = 80

var movement_locked := false
var dir: int

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var animal_state: AnimalState.Animal_state
var has_mount: bool = false
var mount: Player2D

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
		direction = Input.get_axis("left", "right")
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
	velocity.y = jump_velocity

func set_animal_state(new_state: AnimalState.Animal_state) -> void:
	animal_state = new_state
	if animal_state == AnimalState.Animal_state.ACTIVE:
		$StateMachine.set_active(true)
		#get_viewport().get_camera_2d().zoom = Vector2(camera_zoom, camera_zoom)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(get_viewport().get_camera_2d(), "zoom", Vector2(camera_zoom, camera_zoom), 0.5)
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
	for i in range (1,get_child_count()-1):
		if get_child(i).is_class("CollisionShape2D"):
			remove_child(get_child(i))


func _unhandled_input(event: InputEvent) -> void:
	if animal_state == AnimalState.Animal_state.ACTIVE:
		if event.is_action_pressed("jump"):
			if Input.is_action_pressed("down") and has_mount:
				dismount(false)
			elif Input.is_action_pressed("up") and has_mount:
				dismount(true)
			elif not movement_locked and is_on_floor():
				jump()
				
func flip_mount():
	if not has_mount: return
	mount.sprite_2d.flip_h = !mount.sprite_2d.flip_h
	mount.flip_mount()
	
