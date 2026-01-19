extends Area2D

@onready var animal := get_parent()

@onready var original_pos_x = position.x

func _physics_process(_delta: float) -> void:
	if animal.sprite_2d.flip_h:
		position.x = -original_pos_x
	else:
		position.x = original_pos_x

func _on_body_entered(body: Node2D) -> void:
	if get_parent().has_mount: return
	if body.is_in_group("Animal") and body.name != get_parent().name:
		if body.animal_state == AnimalState.Animal_state.ACTIVE:
			if body.velocity.y > 0 and body.global_position.y < get_parent().global_position.y - get_parent().height / 2 + 12:
				AudioManager.play_sound(get_parent().animal_sound)
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
		temp_mount = temp_mount.mount
