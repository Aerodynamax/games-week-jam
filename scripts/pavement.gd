class_name Pavement extends Path2D

var templates: Array[Resource]
var jaywalking_templates: Array[Resource]
var is_road: bool

@export_group("Spawn Timer")
@export var min_spawn_timer: float = 4
@export var max_spawn_timer: float = 10

@export_group("On Ready Spawn")
@export var init_spawn_min: int = 8
@export var init_spawn_max: int = 15

@export_group("Connecting Paths")
@export var adjacent_paths: Array[Path2D]

@export_group("Jaywalk Timers")
@export var min_jaywalk_timer: float = 6
@export var max_jaywalk_timer: float = 15

var spawn_timer: float = 0
var jaywalk_timer: float = 0

func _ready() -> void:
	var path_manager: PathManager = get_parent()
	templates = path_manager.templates
	jaywalking_templates = path_manager.templates
	is_road = path_manager.is_road
	
	var initial_spawn = randi_range(init_spawn_min, init_spawn_max)
	for i in initial_spawn:
		var npc = templates.pick_random().instantiate()
		add_child(npc)
		if npc as Car:
			npc.randomly_place_on_path()

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer < 0:
		_spawn_npc()
	
	if !is_road:
		jaywalk_timer -= delta
		if jaywalk_timer < 0:
			_spawn_jaywalker()

func _spawn_npc() -> PathFollow2D:
	var npc = templates.pick_random().instantiate()
	call_deferred("add_child", npc)
	_randomise_spawn_timer()
	return npc

func _spawn_jaywalker() -> void:
	var random_point: Vector2 = curve.get_baked_points()[randi_range(0, curve.get_baked_points().size() - 1)]
	var opposite_side: Path2D = _get_opposite_side(random_point)
	if opposite_side == null:
		return
	var npc = jaywalking_templates.pick_random().instantiate()
	get_tree().root.call_deferred("add_child", npc)
	npc.position = random_point
	npc.cross_road(opposite_side)
	_randomise_jaywalk_timer()

func _randomise_spawn_timer() -> void:
	spawn_timer = randf_range(min_spawn_timer, max_spawn_timer)

func _randomise_jaywalk_timer() -> void:
	jaywalk_timer = randf_range(min_jaywalk_timer, max_jaywalk_timer)

func _get_opposite_side(point: Vector2) -> Path2D:
	var closest_path: Path2D
	var closest_point: Vector2 = Vector2.INF
	for path in adjacent_paths:
		var point_on_path = path.curve.get_closest_point(point)
		if sqrt(closest_point.distance_squared_to(point)) > sqrt(point_on_path.distance_squared_to(point)):
			closest_path = path
			closest_point = point_on_path
	if closest_point == Vector2.INF:
		return null
	return closest_path
