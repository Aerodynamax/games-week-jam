class_name Player
extends CharacterBody2D


func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

@onready var camera := $Camera2D


#region movement

@export_group("forwards / backwards")
@export_range(1.0, 4.0, 0.05, "or_greater", "or_less") var acceleration := 2.5
@export_range(1.0, 4.0, 0.05, "or_greater", "or_less") var deceleration := 3.5
## When at slow speeds, make the player come to a full stop quicker by increasing the deceleration
@export_range(1.0, 4.0, 0.05, "or_greater", "or_less") var stopping_deceleration := 5.0

var velocity_speed := 5.0

## the max speed while going forwards
@export_range(100.0, 900.0, 1, "or_greater", "or_less") var max_speed := 600.0
## The max speed while going backwards
@export_range(100.0, 500.0, 1, "or_greater", "or_less") var max_speed_backwards := 150.0

var _forwards_lerp_acc: float = 0.0
var _forwards_lerp_vel: float = 0.0

func movement(delta: float) -> Vector2:
	var forwards := Input.get_axis("backward", "forward")
	
	var _acc = acceleration
	# decelerate when out of drift
	if forwards < 0 and _forwards_lerp_vel < drift_min_forward_speed:
		_acc = deceleration
	
	print(_forwards_lerp_vel)
	
	_forwards_lerp_acc = round_to_dec(lerpf(_forwards_lerp_acc, forwards, delta * _acc), 3)
	
	# stop abruptly if not moving
	if _forwards_lerp_acc < 0.05 and forwards == 0:
		_forwards_lerp_acc = 0
	
	if _forwards_lerp_acc > 0.2:
		_forwards_lerp_vel = round_to_dec(lerpf(_forwards_lerp_vel, _forwards_lerp_acc * max_speed, delta * velocity_speed), 3)
	else:
		_forwards_lerp_vel = round_to_dec(lerpf(_forwards_lerp_vel, _forwards_lerp_acc * max_speed_backwards, delta * velocity_speed), 3)
	
	
	# stop abruptly
	if _forwards_lerp_vel < 0.5 and forwards == 0:
		_forwards_lerp_vel = 0
	
	return transform.x * _forwards_lerp_vel

#endregion

#region rotation

@export_group("Turning", "turning")
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_speed: float = 2.4
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_acceleration: float = 2.0
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_deceleration: float = 5.0
var _rotation_vel: float = 0.0



func steer(delta: float):
	var rotation_direction := Input.get_axis("left", "right")
	
	var true_turning_speed = turning_speed
	
	# stop rotating quickly when the keys aren't pressed
	var lerp_amount = turning_deceleration
	if rotation_direction != 0:
		lerp_amount = turning_acceleration
	
	_rotation_vel = round_to_dec(lerpf(_rotation_vel, rotation_direction * true_turning_speed, delta * lerp_amount), 3)
	
	global_rotation += _rotation_vel * true_turning_speed * delta

#endregion

#region drift

@export_group("Drifting", "drift")
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var drift_min_rot_speed: float = 2.0
@export_range(150, 450, 1, "or_greater", "or_less") var drift_min_forward_speed: float = 300.0
@export_range(150, 500, 1, "or_greater", "or_less") var drift_max_speed: float = 400.0
@export_range(3.0, 8.0, 0.1, "or_greater", "or_less") var drift_friction_deceleration: float = 5.0

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

#region camera

@export_group("Camera", "camera")
## the camera zoom when going at max speed / any speed above `zoomed out speed`.
@export_range(0.5, 1.5, 0.1, "or_greater", "or_less") var camera_zoomed_out: float = 0.7
## the camera zoom when not moving / any speed below `zoomed in speed`.
@export_range(0.5, 1.5, 0.1, "or_greater", "or_less") var camera_zoomed_in: float = 1.0

## the speed where the camera starts zooming out.  Any speeds above this will have the camera transitioning between zoomed in & out, any speeds below this will be locked to the zoomed in camera zoom
@export_range(100, 600, 1, "or_greater", "or_less") var camera_zoomed_in_speed: float = 300.0
## the speed where the camera starts zooming in.  Any speeds below this will have the camera transitioning between zoomed in & out, any speeds above this will be locked to the zoomed out camera zoom
@export_range(100, 600, 1, "or_greater", "or_less") var camera_zoomed_out_speed: float = 500.0

func camera_movement(delta: float):
	
	var camera_zoom_percent: float = clampf((abs(_forwards_lerp_vel) - camera_zoomed_in_speed) / camera_zoomed_out_speed, 0, 1)
	
	var camera_zoom_amount: float = camera_zoomed_in - (camera_zoomed_in - camera_zoomed_out) * camera_zoom_percent

	camera.zoom = Vector2.ONE * camera_zoom_amount

#endregion

func _physics_process(delta: float) -> void:
	var _vel = movement(delta)
	steer(delta)
	var _drift_vel = drift(delta)
	# make the camera not follow the drift horizontal velocity
	camera.offset = _drift_vel * delta
	
	camera_movement(delta)
	
	_vel += _drift_vel
	
	velocity = _vel
	move_and_slide()
