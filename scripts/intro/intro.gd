extends Control

func _ready() -> void:
	Dialogic.start("intro_timeline")
	Dialogic.signal_event.connect(_start_game)
	$AudioStreamPlayer2D.play()

func _start_game(_args: String) -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
