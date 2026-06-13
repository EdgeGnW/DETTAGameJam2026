extends Line2D

# Reference to the Line2D node
@export var node2d: Node2D
# Maximum number of points in the trail
@export var max_points: int = 20
# Distance between points
@export var point_spacing: float = 20
# Used to control the spacing between trail points
var distance_accum: float = 0.0

func _ready():
	if node2d == null:
		print("Error: node2d is not assigned. Please assign it in the editor.")
		return
	# Ensure the Line2D node is empty at the start
	clear_points()
	
func _process(delta):
	if node2d == null:
		return
	var start_position = node2d.position#get_viewport().get_start_position()
	# Calculate the distance from the last point to the current mouse position
	if get_point_count() > 0:
		var last_point = get_point_position(get_point_count() - 1)
		var distance = start_position.distance_to(last_point)
		distance_accum += distance
	else:
		distance_accum = point_spacing # Ensure the first point is added
	# Add a new point if the accumulated distance exceeds the spacing
	if distance_accum >= point_spacing:
		add_point(start_position)
		distance_accum = 0.0
		# Remove the oldest point if we exceed the max number of points
		if get_point_count() > max_points:
			remove_point(0)
# Optionally, you can reset the trail
func reset_trail():
	clear_points()
	distance_accum = 0.0
