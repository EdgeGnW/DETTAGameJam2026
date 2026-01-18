extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	var animals_in_range = get_overlapping_bodies()
	if animals_in_range.size() == 4:
		$LightsOff.hide()
		$LightsOn.show()
