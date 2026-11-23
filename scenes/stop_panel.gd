extends Panel

var stops: Array  = ["Stop 1", "Stop 2", "Stop 3", "Step 4", "Step 5", "Step 6"]
var current_stop: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in range(0, stops.size()):
		get_node("Stop" + str(i+1)).text = stops[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_highlight_stop()
	
	
func get_current_stop (): 
	stops[current_stop]

func next():
	current_stop += 1
	
func _highlight_stop ():
	pass
	
