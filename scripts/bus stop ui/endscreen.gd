class_name EndScreen
extends Control

@onready var timelabel : Label = get_node("Sprite2D/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Time")
@onready var scorelabel : Label = get_node("Sprite2D/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Score")
@onready var ranklabel : Label = get_node("Sprite2D/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Rank")
@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var colorrect : ColorRect = get_node("ColorRect")

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
		ranklabel.text = str(scorecalc) + " YEARS!!!"

func scroll():
	var tween = create_tween()
	
	
	tween.tween_property(sprite, "position", Vector2(573.0, 401.0), 1)
	get_tree().paused = true
	


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
