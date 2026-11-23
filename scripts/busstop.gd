extends Node2D

@onready var player : CharacterBody2D = Global.player
@onready var progressBar : ProgressBar = get_node("ProgressBar")
@export var wait_Time : float = 2.0
@export var wait_Distance : int = 300
@export var loc_Name: String 
@export var loc_time: int
var waited_Time = 0
var selected = false
var finished = false
var current = false


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
