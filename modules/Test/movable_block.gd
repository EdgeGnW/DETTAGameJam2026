extends RigidBody2D


func _ready() -> void:
	$StaticBody2D.add_collision_exception_with(self)
