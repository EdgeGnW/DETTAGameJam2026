extends Area2D

var has_mount: bool = false

func _on_body_entered(body: Node2D) -> void:
	if has_mount: return
	if body.is_in_group("Animal") and body.name != get_parent().name:
		if body.velocity.y > 0:
			has_mount = true
			get_parent().set_animal_state(get_parent().Animal_state.ACTIVE)
			body.set_animal_state(get_parent().Animal_state.RIDING)
			var pos = body.global_position
			if body.get_parent():
				body.get_parent().remove_child(body)
			add_child(body)
			body.global_position = pos
			body.global_position.x = global_position.x
