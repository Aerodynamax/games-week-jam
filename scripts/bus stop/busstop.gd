class_name BusStop
extends Node2D

@onready var player : CharacterBody2D = Global.player
@export var wait_Time : float = 2.0
@export var wait_Distance : int = 80.0
@export var loc_Name: String
@export var loc_time: int

@onready var tracker := $tracker
@onready var progress_bar = $ProgressBar
@onready var stop_done: AudioStreamPlayer2D = %StopDone

func _ready() -> void:
	progress_bar.rotation -= rotation
	progress_bar.visibility_changed.connect(_visiblity_changed)
	current = current
	
	Global.score = 0


var waited_Time: float = 0:
	set(val):
		waited_Time = val
		emit_on_update()

var finished: bool = false:
	set(val):
		finished = val
		if tracker is Sprite2D and finished:
			tracker.visible = false
		
		emit_on_update()

var current: bool = false:
	set(val):
		current = val
		if tracker is Sprite2D:
			tracker.visible = current
		emit_on_update()

var completed_time: int:
	set(val):
		completed_time = val
		emit_on_update()

signal on_update(name: String, time: int, waited_time: float, finished: bool, current: bool, completed_time: int)

func emit_on_update():
	on_update.emit(
		loc_Name,
		loc_time,
		waited_Time,
		finished,
		current,
		completed_time
	)

func _physics_process(delta: float) -> void:
	if current:
		progress_bar.visible = player.global_position.distance_to(global_position) <= wait_Distance
		if player.global_position.distance_to(global_position) <= wait_Distance:
			progress_bar.value = 100 - waited_Time/wait_Time * 100
			waited_Time+=delta
			if waited_Time>wait_Time and not finished:
				change_target()
				progress_bar.hide()
				stop_done.play()
				finished = true
		if Global.timetable.get_time()>loc_time:
			Global.Endscreen.fail()
			Global.Endscreen.scroll()
	

func change_target():
	Global.timetable.change_target()

# Hacky but works hopefully
func _visiblity_changed() -> void:
	Global.bus_stop_approached.emit(progress_bar.visible)
