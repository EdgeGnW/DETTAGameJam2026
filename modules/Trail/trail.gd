class_name Trail
extends Line2D

# Reference to the Line2D node
var node2d: Node2D
# Maximum number of points in the trail
var max_points: int = 20
# Distance between points
var point_spacing: float = 100
# Used to control the spacing between trail points
var distance_accum: float = 0.0

var random_offset: float = 2.5

func _ready():
	clear_points()
	
func _process(delta):
	if node2d == null:
		call_deferred("free")
	if not node2d.visible: return
	var start_position = node2d.position#get_viewport().get_start_position()
	
	for i in range(len(points)):
		var rand_vec = Vector2(randf_range(0,random_offset), 0).rotated(randf_range(0,PI*2))
		points[i] += rand_vec
	
	# Calculate the distance from the last point to the current position
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
