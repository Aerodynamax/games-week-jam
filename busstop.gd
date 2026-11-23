extends Node2D

@onready var player : CharacterBody2D 
@export var wait_Time : float = 2.0
@export var wait_Distance : int = 300
@export var loc_name: String = "Poopie"
var waited_Time = 0


func _physics_process(delta: float) -> void:
	if player.global_position.distance_to(global_position) <= wait_Distance:
		waited_Time+=delta
		if waited_Time>wait_Time:
			change_target()

func change_target():
	pass
