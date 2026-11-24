class_name BusStop
extends Node2D

@onready var player : CharacterBody2D = Global.player
@onready var progressBar : ProgressBar = get_node("ProgressBar")
@export var wait_Time : float = 2.0
@export var wait_Distance : int = 80.0
@export var loc_Name: String
@export var loc_time: int

@onready var tracker := $tracker

func _ready() -> void:
	$ProgressBar.rotation -= rotation


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
		progressBar.visible = player.global_position.distance_to(global_position) <= wait_Distance
		if player.global_position.distance_to(global_position) <= wait_Distance:
			progressBar.value = 100 - waited_Time/wait_Time * 100
			waited_Time+=delta
			if waited_Time>wait_Time and not finished:
				change_target()
				progressBar.hide()
				finished = true

func change_target():
	Global.timetable.change_target()
