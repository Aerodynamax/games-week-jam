class_name EndScreen
extends Control

@onready var timelabel : Label = $Node2D/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Time
@onready var scorelabel : Label = $Node2D/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Score
@onready var ranklabel : Label = $Node2D/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Rank
@onready var node2d : Node2D = $Node2D
@onready var colorrect : ColorRect = $ColorRect

var over = false

func calculate_scores():
	var time = Global.timetable.get_time() - 540
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60
	var score = Global.score
	
	timelabel.text = "%02d:%02d" % [minutes, seconds]
	scorelabel.text = "$" + str(score) 
	var scorecalc = score/time
	if scorecalc>70:
		ranklabel.text = "LIFE!!!"
	else:
		ranklabel.text = str(int(scorecalc)) + " YEARS!!!"

func fail():
	timelabel.text = "YOU"
	scorelabel.text = "ARE"
	ranklabel.text = "FIRED"

func scroll():
	var tween = create_tween()
	
	if !over:
		$AudioStreamPlayer2D.play()
		print("Audio test")
		over = true
	
	tween.tween_property(node2d, "position", Vector2(573.0, 300.0), 1)
	
	Global.player.end()
	
	
	if Input.is_action_pressed("reboot_game"):
		get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_button_pressed() -> void:
	var tween = create_tween()
	colorrect.show()
	tween.tween_property(colorrect, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	await tween.finished
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ready() -> void:
	colorrect.show()
	var tween = create_tween()
	
	tween.tween_property(colorrect, "color", Color(0.0, 0.0, 0.0, 0.0), 1)
	await tween.finished
	colorrect.hide()
