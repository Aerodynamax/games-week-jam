class_name TimeTable
extends Control

@onready var timetable = get_node("Panel2")
@onready var timer = get_node("Panel")
@onready var score = get_node("Score")

func change_target():
	timetable.next(timer.time)

func get_time() -> int:
	return timer.time

func get_score() -> int:
	return score.score 


func add_score(points : int):
	score.add_score(points)
