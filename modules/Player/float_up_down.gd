extends AnimatedSprite2D

func _process(_delta: float) -> void:
	position.y = sin(Time.get_ticks_msec() * 0.005) * 4
