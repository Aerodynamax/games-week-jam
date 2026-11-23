class_name TimetableSlot
extends Control

@onready var Location : Label = get_node("Panel/HBoxContainer/Location")
@onready var Locationtime : Label = get_node("Panel/HBoxContainer/Time")
@onready var selected :Panel = get_node("Panel")
var loc_name : String
var loc_time: int
var selected_style = Color(0.485, 0.485, 0.485, 1.0)
var finished_style = Color(0.117, 0.117, 0.117, 1.0)

func _on_update(name: String, time: int, waited_time: float, finished: bool, current: bool, completed_time: int):
	loc_name = name
	loc_time = time
	
	if current:
		self.point_selected()
	if finished and completed_time > 0:
		self.point_reached(completed_time)

func setup(stop: BusStop):
	stop.on_update.connect(_on_update)
	loc_name = stop.loc_Name
	loc_time = stop.loc_time

func _ready() -> void:
	Location.text = loc_name
	Locationtime.text = get_time(loc_time)

func point_selected():
	var stylebox : StyleBoxFlat = selected.get_theme_stylebox("panel").duplicate()
	stylebox.bg_color = selected_style
	selected.add_theme_stylebox_override("panel", stylebox)

func point_reached(time:int):
	Locationtime.text = get_time(time)
	var stylebox : StyleBoxFlat = selected.get_theme_stylebox("panel").duplicate()
	stylebox.bg_color = finished_style
	selected.add_theme_stylebox_override("panel", stylebox)

func get_time(time:int) -> String:
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60
	return "%02d:%02d" % [minutes, seconds]
