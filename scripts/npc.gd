class_name NPC extends PathFollow2D

var move_dir: int
@export var move_speed: float = 10

func _ready() -> void:
	progress_ratio = randf_range(0, 1) # selects a random point along the path for the NPC to start
	move_dir = 1 if randi_range(0, 1) == 0 else -1 # selects a random direction to move along the path (either forwards or backwards)

func _process(delta: float) -> void:
	_move_along_path(delta)

# increment progress based on move direction and move speed - when the NPC reaches the end currently the direction swaps around so they move back along the path in the other direction (logic in the else condition)
func _move_along_path(delta: float) -> void:
	if progress_ratio != 1 && move_dir != -1 || progress_ratio != 0 && move_dir != 1:
		progress += delta * move_dir * move_speed
	else:
		move_dir *= -1
