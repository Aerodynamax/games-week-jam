class_name NPC extends PathFollow2D

var move_dir: int
@export var move_speed: float = 10

var is_crossing: bool = false
var crossing_dest_path: Path2D = null
var crossing_start_point: Vector2
var crossing_end_point: Vector2
var crossing_distance: float
var crossing_progress: float
var lerp_time: float = 0
var time_to_cross: float
@export var crossing_cooldown: float = 3
var time_since_crossing: float = crossing_cooldown

@onready var area: Area2D = $StaticBody2D

func _ready() -> void:
	progress_ratio = randf_range(0, 1) # selects a random point along the path for the NPC to start
	move_dir = 1 if randi_range(0, 1) == 0 else -1 # selects a random direction to move along the path (either forwards or backwards)

func _process(delta: float) -> void:
	if !is_crossing:
		time_since_crossing += delta
		_move_along_path(delta)
	else:
		_move_at_crossing(delta)

# increment progress based on move direction and move speed - when the NPC reaches the end currently the direction swaps around so they move back along the path in the other direction (logic in the else condition)
func _move_along_path(delta: float) -> void:
	if progress_ratio != 1 && move_dir != -1 || progress_ratio != 0 && move_dir != 1:
		progress += delta * move_dir * move_speed
	else:
		move_dir *= -1

func try_cross_road(dest_path: Path2D) -> void:
	if time_since_crossing < crossing_cooldown:
		return
	print("trying to cross road")
	if randf_range(0, 1) <= 0.5: #currently set to a 50% chance of crossing the road at a crossing
		is_crossing = true
		crossing_dest_path = dest_path
		crossing_start_point = position
		crossing_end_point = dest_path.curve.get_closest_point(position)
		var distance = sqrt(crossing_start_point.distance_squared_to(crossing_end_point))
		time_to_cross = distance / move_speed
		lerp_time = 0
		time_since_crossing = 0
		call_deferred("reparent", $/root/Main)

func _move_at_crossing(delta) -> void:
	lerp_time += delta
	if (lerp_time <= time_to_cross):
		position = lerp(crossing_start_point, crossing_end_point, lerp_time / time_to_cross)
	else:
		reparent(crossing_dest_path)
		is_crossing = false
		var progress_tracker = 0;
		while sqrt(position.distance_squared_to(crossing_end_point)) >= 5:
			progress_tracker += 0.1
			progress_ratio = progress_tracker
