class_name Pavement extends Path2D

@export var npc_templates: Array[Resource]
@export var npc_min_spawn_timer: float = 4
@export var npc_max_spawn_timer: float = 10

var npc_spawn_timer: float = 0

func _process(delta: float) -> void:
	npc_spawn_timer -= delta
	if npc_spawn_timer < 0:
		_spawn_npc()

func _spawn_npc() -> void:
	var npc = npc_templates.pick_random().instantiate()
	call_deferred("add_child", npc)
	_randomise_spawn_timer()

func _randomise_spawn_timer() -> void:
	npc_spawn_timer = randf_range(npc_min_spawn_timer, npc_max_spawn_timer)
