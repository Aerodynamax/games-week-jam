extends Node2D

@export var destruction_velocity: float = 300.0
@export var value : float = 10.01

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var Collisionshape : CollisionShape2D
@export var area2d : Area2D
@export var Sprite : Sprite2D

@onready var explosion_audio: AudioStreamPlayer2D = $ExplosionAudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hi")
	area2d.connect("body_entered", _on_area_2d_body_entered)




	


#func _on_body_entered(body: Node) -> void:
	#print("hello")
	#Global.player.stop_movement()
	#Global.player.apply_impulse(Global.player.transform.x * -300) # Replace with function body.



func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		if not get_parent() is RigidBody2D:
			get_parent().dead = true
		
		if (body.get_velocity().length() > destruction_velocity):
			
			# audio
			explosion_audio.play()
			
			print("Too fast!")
			Collisionshape.set_deferred("disabled", true)
			area2d.set_deferred("monitoring", false)
			animated_sprite_2d.frame=0
			animated_sprite_2d.play("explosion")
			var tween = get_tree().create_tween()
			tween.tween_property(Sprite, "modulate:a", 0.2, 1.0)
			Global.score += value
			tween.tween_property(Sprite, "modulate:a:", 0.0, 1.0)
			await tween.finished
			await explosion_audio.finished
			get_parent().queue_free()
		elif(body.get_velocity().length() < 0 and body.get_velocity().length() > -destruction_velocity):
			body.stop_movement()
			body.apply_impulse(body.transform.x * -300)
		else:
			print("You aren't fast enough")
			body.stop_movement()
			body.apply_impulse(body.transform.x * -300)
			
	
