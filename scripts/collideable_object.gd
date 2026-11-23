extends RigidBody2D

@export var destruction_velocity: float = 300.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hi")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	


#func _on_body_entered(body: Node) -> void:
	#print("hello")
	#Global.player.stop_movement()
	#Global.player.apply_impulse(Global.player.transform.x * -300) # Replace with function body.

const COOKED_SPRITE = preload("res://assets/cooked_godot.png")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		if (body.get_velocity().length() > destruction_velocity):
			print("Too fast!")
			$CollisionShape2D.set_deferred("disabled", true)
			$Area2D.set_deferred("monitoring", false)
			$AnimatedSprite2D.play("explosion")
			$Sprite2D.texture = COOKED_SPRITE
			var tween = get_tree().create_tween()
			tween.tween_property($Sprite2D, "modulate:a", 0.2, 1.0)
			
		elif(body.get_velocity().length() < 0 and body.get_velocity().length() > -destruction_velocity):
			body.stop_movement()
			body.apply_impulse(body.transform.x * -300)
		else:
			print("You aren't fast enough")
			body.stop_movement()
			body.apply_impulse(body.transform.x * -300)
			
	
