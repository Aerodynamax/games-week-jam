extends TextureButton

# DON'T GET NODES THIS WAY IN A REAL PROJECT!!! I am just a lazy bastard. - Dom
@onready var audio_mute: TextureButton = $"../AudioMute"
@onready var music_mute: TextureButton = $"../MusicMute"

func _ready() -> void:
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX")):
		audio_mute.button_pressed = true
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")):
		music_mute.button_pressed = true


func _on_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_audio_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), toggled_on)


func _on_music_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), toggled_on)
