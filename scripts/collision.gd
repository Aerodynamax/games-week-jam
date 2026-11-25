extends Node2D

@export var destruction_velocity: float = 300.0
@export var value : float = 10.01

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var Collisionshape : CollisionShape2D
@export var area2d : Area2D
@export var Sprite : Sprite2D

@onready var explosion_audio: AudioStreamPlayer2D = $ExplosionAudio
@onready var crash_audio: AudioStreamPlayer2D = $CrashAudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2d.connect("body_entered", _on_area_2d_body_entered)




	


#func _on_body_entered(body: Node) -> void:
	#print("hello")
	#Global.player.stop_movement()
	#Global.player.apply_impulse(Global.player.transform.x * -300) # Replace with function body.



func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		
		
		if (body.get_velocity().length() > destruction_velocity):
			
			if not get_parent() is RigidBody2D:
				get_parent().dead = true
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
		else:
			print("You aren't fast enough")
			print("truly")
			
			body.stop_movement()
			
			# push the player with the car/npc velocity
			var push_vel: Vector2
			var non_player = get_parent()
			if non_player is Car or non_player is NPC or non_player is CrossingNPC:
				push_vel = non_player.move_speed * non_player.transform.x
			
			if non_player is NPC:
				# npcs can go forwards or backwards
				push_vel *= non_player.move_dir
			
			if push_vel:
				body.apply_impulse(push_vel * 3)
				crash_audio.volume_db += min((push_vel.length() / 50), 2)
			
			# get reflection of player movement
			var collision: KinematicCollision2D
			if body.get_velocity().length() > 0:
				collision = body.get_next_collision()
			if collision:
				var reflect = collision.get_remainder().bounce(collision.get_normal())
				body.apply_impulse(reflect)
			
			if !crash_audio.playing:
				crash_audio.play()
			print("Rumour has it that audio just played...")
			
			#body.apply_impulse(
				#(global_position.direction_to(body.global_position)) * 300
			#)
			#body.apply_impulse(body.transform.x * -100)
