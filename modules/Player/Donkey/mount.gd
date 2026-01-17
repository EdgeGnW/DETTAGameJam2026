extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if get_parent().has_mount: return
	if body.is_in_group("Animal") and body.name != get_parent().name:
		if body.animal_state == AnimalState.Animal_state.ACTIVE:
			if body.velocity.y > 0:
				get_parent().has_mount = true
				get_parent().mount = body
				get_parent().set_animal_state(AnimalState.Animal_state.ACTIVE)
				body.set_animal_state(AnimalState.Animal_state.RIDING)
				#var pos = body.global_position
				if body.get_parent():
					body.get_parent().remove_child(body)
				call_deferred("attach", body)


func attach(body: Player2D):
	add_child(body)
	#body.global_position = pos
	body.global_position.x = global_position.x
	body.global_position.y = global_position.y - body.height / 2
	body.get_node("StateMachine").current_state.transition.emit("Idle")
	var temp_mount = body
	while temp_mount != null:
		var collision_shape = temp_mount.get_child(0).duplicate()
		var pos = temp_mount.global_position
		get_parent().add_child(collision_shape)
		collision_shape.global_position = pos
		print(pos)
		temp_mount = temp_mount.mount
		print(temp_mount)
