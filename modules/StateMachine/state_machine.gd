class_name StateMachine

extends Node

@export var current_state: State
@export var subject: Node
var states: Dictionary = {}

var active: bool


func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.set_subject(subject)
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node")
	current_state.enter()
	
func _process(delta: float) -> void:
	if active:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if active:
		current_state.physics_update(delta)
	
func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state:
		if new_state == current_state:
			push_warning("Reentering state %s" % new_state_name)
		current_state.exit()
		new_state.enter()
		current_state = new_state
	else:
		push_warning("State does not exist")
		
func set_active(new_active: bool) -> void:
	active = new_active
