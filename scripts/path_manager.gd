class_name PathManager extends Node2D

@export var templates: Array[Resource]
@export var jaywalking_templates: Array[Resource]
@export var is_road: bool

var paths

func _ready() -> void:
	paths = get_children()

func get_opposite_side(point: Vector2, calling_path: Path2D) -> Path2D:
	var closest_path: Path2D
	var closest_point: Vector2 = Vector2.INF
	for path in paths:
		if path == calling_path:
			continue
		var point_on_path = path.curve.get_closest_point(point)
		if sqrt(closest_point.distance_squared_to(point)) > sqrt(point_on_path.distance_squared_to(point)):
			closest_path = path
			closest_point = point_on_path
	if closest_point == Vector2.INF:
		return null
	return closest_path
