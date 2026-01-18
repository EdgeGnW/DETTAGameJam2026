extends Area2D

@onready var dog = get_parent()
var grabbed_body: CharacterBody2D
var old_parent
@onready var grab_pos: Node2D = $Node2D

func _physics_process(_delta: float) -> void:
	
	if dog.sprite_2d.flip_h:
		position.x = -abs(position.x)
		scale.x = -1
	else:
		position.x = abs(position.x)
		scale.x = 1


func _on_body_entered(_body: Node2D) -> void:
	$Label.show()


func _on_body_exited(_body: Node2D) -> void:
	var bodies = get_overlapping_bodies()
	if len(bodies) < 1:
		$Label.hide()
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		if grabbed_body:
			grabbed_body.reparent(old_parent)
			grabbed_body.process_mode = Node.PROCESS_MODE_INHERIT
			grabbed_body = null
			
			
		if $Label.visible and not grabbed_body:
			$Label.hide()
			var body = get_overlapping_bodies()[0]
			grabbed_body = body
			body.process_mode = Node.PROCESS_MODE_DISABLED
			old_parent = body.get_parent()
			body.reparent(grab_pos)
			body.position = Vector2.ZERO
			
	
	
