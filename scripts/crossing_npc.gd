class_name CrossingNPC extends StaticBody2D

@export var move_speed: float = 10
@export var existence_duration: float = 5
var crossing_dest_path: Path2D = null
var crossing_start_point: Vector2
var crossing_end_point: Vector2
var crossing_distance: float
var crossing_progress: float
var lerp_time: float = 0
var time_to_cross: float
var dead = false


var timer: float

func _process(delta: float) -> void:
	if dead: return
	_move_at_crossing(delta)

func cross_road(dest_path: Path2D) -> void:
	crossing_dest_path = dest_path
	crossing_start_point = position
	crossing_end_point = dest_path.curve.get_closest_point(position)
	var distance = sqrt(crossing_start_point.distance_squared_to(crossing_end_point))
	time_to_cross = distance / move_speed
	lerp_time = 0

func _move_at_crossing(delta) -> void:
	lerp_time += delta
	if (lerp_time <= time_to_cross):
		position = lerp(crossing_start_point, crossing_end_point, lerp_time / time_to_cross)
	else:
		timer += delta
		if timer > existence_duration:
			queue_free()
