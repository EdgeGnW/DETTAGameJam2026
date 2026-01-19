extends RichTextLabel

@onready var i: int = 0
#@onready var tween: Tween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.get_parent().visible:
		global_position.y += (100 * delta) * (-0.5)
	else:
		global_position.y = 750
	if global_position.y <= -320:
		global_position.y = 750
