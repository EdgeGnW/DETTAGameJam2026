extends Area2D
class_name Switch

@export var door_index: int
var pressed = false
signal updated()


func _on_body_entered(_body: Node2D) -> void:
	if not pressed:
		pressed = true
		$Default.hide()
		$Pressed.show()
		updated.emit()
		


func _on_body_exited(_body: Node2D) -> void:
	if not pressed: return
	var bodies = get_overlapping_bodies()
	if len(bodies) < 1:
		pressed = false
		$Default.show()
		$Pressed.hide()
		updated.emit()
	
