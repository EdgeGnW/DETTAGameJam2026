extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if get_parent().has_mount: return
	if body.is_in_group("Animal") and body.name != get_parent().name:
		if body.animal_state == AnimalState.Animal_state.ACTIVE:
			if body.velocity.y > 0:
				get_parent().has_mount = true
				get_parent().set_animal_state(AnimalState.Animal_state.ACTIVE)
				body.set_animal_state(AnimalState.Animal_state.RIDING)
				#var pos = body.global_position
				if body.get_parent():
					body.get_parent().remove_child(body)
				add_child(body)
				#body.global_position = pos
				body.global_position.x = global_position.x
				body.global_position.y = global_position.y - body.height / 2
