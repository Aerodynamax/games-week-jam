extends Panel

var stops: Array  = []
var timetables:Array = []
var current_stop: int = 0
@export var timetableslot : PackedScene
@onready var vBox : VBoxContainer = get_node("HBoxContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in get_tree().get_nodes_in_group("busstop"):
		stops.append(i)
		var new_timetable = timetableslot.instantiate()
		new_timetable.setup(i.loc_Name, i.loc_time)
		timetables.append(new_timetable)
		vBox.add_child(new_timetable)
	timetables[0].point_selected()
	get_current_stop().current = true


func get_current_stop() -> Node2D: 
	return stops[current_stop]

func next(time:int):
	timetables[current_stop].point_reached(time)
	get_current_stop().current = false
	if current_stop>=timetables.size()-1:
		return
	current_stop +=1
	timetables[current_stop].point_selected()
	get_current_stop().current = true
