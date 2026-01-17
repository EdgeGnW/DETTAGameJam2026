extends Area2D
class_name Switch

@export var door_index: int
var pressed = false
signal updated()


func _on_body_entered(_body: Node2D) -> void:
	if not pressed:
		pressed = true
		$Sprite2D.scale.y = 0.5
		updated.emit()
		


func _on_body_exited(_body: Node2D) -> void:
	if not pressed: return
	var bodies = get_overlapping_bodies()
	if len(bodies) < 1:
		pressed = false
		$Sprite2D.scale.y = 1.0
		updated.emit()
	
