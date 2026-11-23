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

func movement(delta: float) -> Vector2:
	var forwards := Input.get_axis("backward", "forward")
	
	_forwards_lerp_acc = round_to_dec(lerpf(_forwards_lerp_acc, forwards, delta * acceleration), 3)
	
	if _forwards_lerp_acc > 0:
		_forwards_lerp_vel = round_to_dec(lerpf(_forwards_lerp_vel, _forwards_lerp_acc * max_speed, delta * velocity_speed), 3)
	else:
		_forwards_lerp_vel = round_to_dec(lerpf(_forwards_lerp_vel, _forwards_lerp_acc * max_speed_backwards, delta * velocity_speed), 3)
	
	return transform.x * _forwards_lerp_vel

#endregion

#region rotation

var turning_speed: float = 2.4
var turning_acceleration: float = 2.0
var turning_deceleration: float = 5.0
var _rotation_vel: float = 0.0

var forward_speed_boost: float = 0.3

func steer(delta: float):
	var rotation_direction := Input.get_axis("left", "right")
	
	var true_turning_speed = turning_speed * ((1 - forward_speed_boost) + (forward_speed_boost * (_forwards_lerp_vel / max_speed)))
	
	# stop rotating quickly when the keys aren't pressed
	var lerp_amount = turning_deceleration
	if rotation_direction != 0:
		lerp_amount = turning_acceleration
	
	_rotation_vel = round_to_dec(lerpf(_rotation_vel, rotation_direction * true_turning_speed, delta * lerp_amount), 3)
	
	global_rotation += _rotation_vel * true_turning_speed * delta

#endregion

#region drift

var drift_min_rot_speed: float = 2.0
var drift_min_forward_speed: float = 300.0
var drift_max_speed: float = 400.0
var drift_friction_deceleration: float = 5.0

var _perpendicular_vel_amount: float = 0.0

func drift(delta: float) -> Vector2:
	# only if going fast enough
	if abs(_rotation_vel) > drift_min_rot_speed and abs(_forwards_lerp_vel) > drift_min_forward_speed:
		var magic_math: float = (abs(_rotation_vel) - (drift_min_rot_speed)) * (_rotation_vel/abs(_rotation_vel)) / (turning_speed - (drift_min_rot_speed))
		
		_perpendicular_vel_amount = clampf(magic_math, -1, 1)
		
	else:
		_perpendicular_vel_amount = 0
	
	return transform.y * -_perpendicular_vel_amount * drift_max_speed


#endregion

func _physics_process(delta: float) -> void:
	var _vel = movement(delta)
	steer(delta)
	_vel += drift(delta)
	
	velocity = _vel
	move_and_slide()
