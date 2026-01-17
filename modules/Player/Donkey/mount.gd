extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Animal"):
		if body.name != get_parent().name:
			var is_child = false
			for x in get_children():
				if x.name == body.name:
					is_child = true
			if not is_child:
				get_parent().animal_state = get_parent().Animal_state.ACTIVE
				body.animal_state = get_parent().Animal_state.RIDING
				var pos = body.global_position
				if body.get_parent():
					body.get_parent().remove_child(body)
				add_child(body)
				body.global_position = pos
				print(body.get_parent())
				print(body.get_children())
				print(body.global_position)
