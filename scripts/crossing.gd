class_name Crossing extends Area2D

@export var side_a: Path2D
@export var side_b: Path2D
@export var npc_templates: Array[Resource]
@export var npc_min_spawn_timer: float = 4
@export var npc_max_spawn_timer: float = 10

var npc_spawn_timer: float = 0
var player_in_range: bool = false
@onready var visible_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _process(delta: float) -> void:
	npc_spawn_timer -= delta
	if npc_spawn_timer < 0 && player_in_range && !visible_notifier.is_on_screen():
		_spawn_npc()

func _get_opposite_side(path: Path2D) -> Path2D:
	if path == side_a:
		return side_b
	else:
		return side_a

func _randomise_spawn_timer() -> void:
	npc_spawn_timer = randf_range(npc_min_spawn_timer, npc_max_spawn_timer)

func _pick_random_side() -> Path2D:
	return side_a if randi_range(0, 1) == 0 else side_b

func _on_body_entered(body: Node2D) -> void:
	if body as Player:
		player_in_range = true

func _spawn_npc() -> void:
	var chosen_side: Path2D = _pick_random_side()
	var opposite_side: Path2D = _get_opposite_side(chosen_side)
	var npc = npc_templates.pick_random().instantiate()
	get_tree().root.call_deferred("add_child", npc)
	npc.position = chosen_side.curve.get_closest_point(position)
	npc.cross_road(opposite_side)
	_randomise_spawn_timer()

func _on_body_exited(body: Node2D) -> void:
	if body as Player:
		player_in_range = false
