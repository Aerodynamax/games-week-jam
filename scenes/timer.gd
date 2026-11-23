extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
var elapsed_seconds: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_timer_timeout() -> void:
	elapsed_seconds += 1
	label.text = "%d" % elapsed_seconds
