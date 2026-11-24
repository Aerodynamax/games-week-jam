class_name Car extends PathFollow2D

@export var move_speed: float = 10

@onready var shapecast: ShapeCast2D = $StaticBody2D/ShapeCast2D
var dead = false


func _process(delta: float) -> void:
	if dead: return
	_move_along_path(delta)
	if progress_ratio == 1 || is_close_to_car():
		queue_free()

# increment progress based on move speed
func _move_along_path(delta: float) -> void:
	progress += delta * move_speed

func is_close_to_car() -> bool:
	shapecast.force_shapecast_update()
	return shapecast.is_colliding()

func randomly_place_on_path() -> void:
	progress_ratio = randf_range(0, 1)
