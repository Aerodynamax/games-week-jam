extends Panel

@onready var timetable: TimeTable = $".."


var timetable_entries: Array[TimetableSlot] = []

@export var timetable_entry_template: PackedScene
@onready var vBox : VBoxContainer = get_node("HBoxContainer/VBoxContainer")


func _ready() -> void:
	setup()

func setup() -> void:
	# add all the stops
	for stop in timetable.stops:
		
		var new_timetable := timetable_entry_template.instantiate() as TimetableSlot
		new_timetable.setup(stop)
		
		timetable_entries.append(new_timetable)
		
		vBox.add_child(new_timetable)
