extends RigidBody2D

@export var destruction_velocity: float = 300.0

@export var value : float = 10.01


#func _on_body_entered(body: Node) -> void:
	#print("hello")
	#Global.player.stop_movement()
	#Global.player.apply_impulse(Global.player.transform.x * -300) # Replace with function body.

@export var cooked : Texture2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		if (body.get_velocity().length() > destruction_velocity):
			print("Too fast!")
			$CollisionShape2D.set_deferred("disabled", true)
			$Area2D.set_deferred("monitoring", false)
			$AnimatedSprite2D.play("explosion")
			$Sprite2D.texture = cooked
			$Sprite2D.rotation = deg_to_rad(randf_range(0,360))
			var tween = get_tree().create_tween()
			tween.tween_property($Sprite2D, "modulate:a", 0.2, 1.0)
			Global.score += value
		elif(body.get_velocity().length() < 0 and body.get_velocity().length() > -destruction_velocity):
			body.stop_movement()
			body.apply_impulse(body.transform.x * -300)
		else:
			print("You aren't fast enough")
			body.stop_movement()
			body.apply_impulse(body.transform.x * -300)
			
	
