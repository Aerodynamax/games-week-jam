extends Panel

var stops: Array  = []
var timetables:Array = []
var current_stop: int = 0
@export var timetableslot : PackedScene
@onready var vBox : VBoxContainer = get_node("HBoxContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stops = get_tree().get_nodes_in_group("busstop")
	
	
	stops.sort_custom(func(a,b): return a.loc_time<b.loc_time)
	
	for i in stops:
		var new_timetable = timetableslot.instantiate()
		new_timetable.setup(i.loc_Name, i.loc_time)
		timetables.append(new_timetable)
		vBox.add_child(new_timetable)
		var kids = vBox.get_children()
		
		
		
	timetables[0].point_selected()
	stops[0].current = true




func next(time:int):
	timetables[current_stop].point_reached(time)
	stops[current_stop].current = false
	if current_stop>=timetables.size()-1:
		return
	current_stop +=1
	timetables[current_stop].point_selected()
	stops[current_stop].current = true
