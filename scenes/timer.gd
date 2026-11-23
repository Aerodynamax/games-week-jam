class_name TimeTable
extends Control

@onready var timetable = get_node("Panel2")
@onready var timer = get_node("Panel")

func change_target():
	timetable.next(timer.time)
