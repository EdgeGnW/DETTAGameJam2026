extends Area2D
class_name Switch

@export var door_index: int
var pressed = false
signal updated(bool)


func _on_body_entered(body: Node2D) -> void:
	if not pressed:
		pressed = true
		updated.emit(pressed)
		


func _on_body_exited(body: Node2D) -> void:
	if not pressed: return
	var bodies = get_overlapping_bodies()
	if len(bodies) < 1:
		pressed = false
		updated.emit(pressed)
	
