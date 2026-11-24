class_name Pavement extends Path2D

@export_group("Templates")
@export var templates: Array[Resource]

@export_group("Spawn Timer")
@export var min_spawn_timer: float = 4
@export var max_spawn_timer: float = 10

@export_group("On Ready Spawn")
@export var init_spawn_min: int = 8
@export var init_spawn_max: int = 15

var spawn_timer: float = 0

func _ready() -> void:
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

func _spawn_npc() -> PathFollow2D:
	var npc = templates.pick_random().instantiate()
	call_deferred("add_child", npc)
	_randomise_spawn_timer()
	return npc

func _randomise_spawn_timer() -> void:
	spawn_timer = randf_range(min_spawn_timer, max_spawn_timer)
