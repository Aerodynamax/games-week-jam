class_name TimeTable
extends Node2D

@onready var timetable = get_node("Panel2")
@onready var timer = get_node("Panel")

func change_target():
	timetable.next(timer.time)
