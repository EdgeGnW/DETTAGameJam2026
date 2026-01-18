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

var wall_jumped: int = 0
var dir: int

@onready var sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

const RAYCAST_LENGTH = 14
@onready var raycast := RayCast2D.new()

@export var animal_state: AnimalState.Animal_state
var has_mount: bool = false
var mount: Player2D

func _ready():
	add_child(raycast)
	raycast.target_position = Vector2(RAYCAST_LENGTH, 0)
	if name != "Cat": raycast.enabled = false

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
		direction = Input.get_axis("left", "right")
	if direction != 0:
		dir = int(direction)
		var flip_h = dir < 0
		if sprite_2d.flip_h != flip_h:
			flip_character()
		
	if wall_jumped and sign(direction) == -wall_jumped:
		velocity.x += direction * speed * delta * 4
		if sign(velocity.x) != wall_jumped and abs(velocity.x) >= speed:
			velocity.x = sign(velocity.x) * speed
			wall_jumped = 0
	elif direction:
		velocity.x = direction * speed
	elif not wall_jumped:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i)
		var collision = collider.get_collider()
		if collision.is_in_group("movables") and name == "Donkey" and abs(collision.get_linear_velocity().x) < MAX_VELOCITY:
			collision.apply_central_impulse(collider.get_normal() * -speed)

func flip_character():
	flip_mount()
	sprite_2d.flip_h = !sprite_2d.flip_h
	raycast.target_position.x *= -1
	
func jump() -> void:
	velocity.y = -sqrt(1000 * jump_height)

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
	mounter.global_position = $Mount.global_position
	if jump_start:
		mounter.jump()
	await get_tree().create_timer(1).timeout
	has_mount = false
	mount = null
	for i in range (1,get_child_count()-1):
		if get_child(i) and get_child(i).is_class("CollisionShape2D"):
			remove_child(get_child(i))


func _unhandled_input(event: InputEvent) -> void:
	if animal_state == AnimalState.Animal_state.ACTIVE:
		if event.is_action_pressed("jump"):
			free_falling = false
			if name != "Rooster" and has_mount and (name == "Donkey" or not is_on_floor()) and (name != "Cat" or not is_on_wall()):
				dismount(true)
			elif not wall_jumped and is_on_floor():
				jump()
		elif event.is_action_released("jump"):
			free_falling = true
			if velocity.y < 0:
				velocity.y *= 0.5
		elif name != "Rooster" and event.is_action_pressed("dismount"):
			dismount(false)
				
func flip_mount():
	if not has_mount: return
	mount.sprite_2d.flip_h = !mount.sprite_2d.flip_h
	mount.flip_mount()
	
func lure(pos: Vector2):
	if animal_state != AnimalState.Animal_state.ALONE: return
	
	var v := pos - global_position
	
	var d := int(sign(v.x))
	
	var flip_h = d < 0
	if sprite_2d.flip_h != flip_h:
		flip_character()
	
	velocity = Vector2(d * speed, 0)
	
	move_and_slide()
	
