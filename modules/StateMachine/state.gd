class_name State
extends Node

signal transition(new_state_name: StringName)

func set_subject(_subject: Node):
	assert(false, "executed abstract method")

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
