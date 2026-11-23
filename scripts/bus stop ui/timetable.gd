class_name TimeTable
extends Control

@onready var timer := $Timer
@onready var stop_list := $StopPanel

var stops: Array[BusStop]

var current_stop: int = 0

func get_all_stops() -> Array[BusStop]:
	var out: Array[BusStop] = []
	
	for stop in get_tree().get_nodes_in_group("busstop"):
		if stop is BusStop:
			out.append(stop)
	
	# sort
	stops.sort_custom(func(a,b): return a.loc_time<b.loc_time)
	
	return out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stops = get_all_stops()
	
	# setup stop list
	stop_list.setup()
	
	stops[0].current = true


func get_current_stop() -> BusStop:
	for stop in stops:
		if stop.current:
			return stop
	
	return null


func change_target():
	self.next(timer.time)


func next(time:int):
	# mark current as completed
	stops[current_stop].finished = true
	stops[current_stop].completed_time = time
	
	
	# set the next one to be current
	if current_stop < stops.size() - 1:
		stops[current_stop].current = false
		current_stop += 1
		stops[current_stop].current = true
	
