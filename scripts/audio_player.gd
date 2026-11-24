class_name AudioPlayer
extends AudioStreamPlayer2D


func audio_load(audio : AudioStream, volume : float, pitch_var : float):
	stream = audio
	pitch_scale = pitch_var
	volume_db = volume
	play()

func _ready() -> void:
	play()

func _on_finished() -> void:
	queue_free()
