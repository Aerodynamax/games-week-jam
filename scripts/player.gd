class_name Player
extends CharacterBody2D


func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

#region movement

var acceleration := 2.5
var velocity_speed   := 5.0

var max_speed := 600.0
var max_speed_backwards := 150.0

var _forwards_lerp_acc: float = 0.0
var _forwards_lerp_vel: float = 0.0

func movement(delta: float):
	var forwards := Input.get_axis("backward", "forward")
	
	_forwards_lerp_acc = round_to_dec(lerpf(_forwards_lerp_acc, forwards, delta * acceleration), 3)
	
	if _forwards_lerp_acc > 0:
		_forwards_lerp_vel = round_to_dec(lerpf(_forwards_lerp_vel, _forwards_lerp_acc * max_speed, delta * velocity_speed), 3)
	else:
		_forwards_lerp_vel = round_to_dec(lerpf(_forwards_lerp_vel, _forwards_lerp_acc * max_speed_backwards, delta * velocity_speed), 3)
	
	velocity = transform.x * _forwards_lerp_vel

#endregion

#region rotation

var turning_speed: float = 4.0
var turning_acceleration: float = 2.0
var _rotation_vel: float = 0.0

func steer(delta: float):
	var rotation_direction := Input.get_axis("left", "right")
	
	_rotation_vel = round_to_dec(lerpf(_rotation_vel, rotation_direction, delta * turning_acceleration), 3)
	
	var true_turning_speed = turning_speed * (_forwards_lerp_vel / max_speed)
	print(true_turning_speed)
	rotation += _rotation_vel * true_turning_speed * delta

#endregion

func _physics_process(delta: float) -> void:
	movement(delta)
	steer(delta)
	move_and_slide()
