extends Panel

var time: float = 540
var hours: int = 0
var minutes: int = 0
var seconds: int = 0
var mseconds: int = 0
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta 
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	
	%Time.text = "%02d:%02d" % [minutes, seconds]
	
	
