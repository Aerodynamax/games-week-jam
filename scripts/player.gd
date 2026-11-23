class_name Player
extends CharacterBody2D


func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

@onready var camera := $Camera2D
@onready var sprite: Sprite2D = $Sprite

#region movement

@export_group("Movement")
@export_range(1.0, 4.0, 0.05, "or_greater", "or_less") var acceleration := 2.0
@export_range(1.0, 4.0, 0.05, "or_greater", "or_less") var deceleration := 4.0
## When at slow speeds, make the player come to a full stop quicker by increasing the deceleration
@export_range(1.0, 4.0, 0.05, "or_greater", "or_less") var stopping_deceleration := 5.0

var velocity_speed := 9.0

## the max speed while going forwards
@export_range(100.0, 900.0, 1, "or_greater", "or_less") var max_speed := 320.0
## The max speed while going backwards
@export_range(100.0, 500.0, 1, "or_greater", "or_less") var max_speed_backwards := 200.0

var _forwards_lerp_acc: float = 0.0
var _forwards_lerp_vel: float = 0.0

func movement(delta: float) -> Vector2:
	var forwards := Input.get_axis("backward", "forward")
	
	var _acc = acceleration
	# decelerate when out of drift
	if forwards < 0 and _forwards_lerp_vel < drift_min_forward_speed:
		_acc = deceleration
	
	
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
@export_range(10, 200, 0.1, "or_greater", "or_less") var turning_min_vel_to_turn: float = 100.0
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_speed: float = 2.4
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_speed_backwards: float = 1.6
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_acceleration: float = 2.0
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var turning_deceleration: float = 5.0

var _rotation_vel: float = 0.0

var prev_rotation: float = 0.0


func steer(delta: float) -> float:
	var rotation_direction := Input.get_axis("left", "right")
	
	# reduce turning when not moving
	var true_turning_speed := turning_speed
	if _forwards_lerp_vel < 0:
		true_turning_speed = turning_speed_backwards
	
	true_turning_speed = true_turning_speed * clampf(absf(_forwards_lerp_vel) / turning_min_vel_to_turn, 0, 1)
	
	
	# stop rotating quickly when the keys aren't pressed
	var lerp_amount = turning_deceleration
	if rotation_direction != 0:
		lerp_amount = turning_acceleration
	
	_rotation_vel = round_to_dec(lerpf(_rotation_vel, rotation_direction * true_turning_speed, delta * lerp_amount), 3)
	
	return _rotation_vel * true_turning_speed * delta

#endregion

#region drift

@export_group("Drifting", "drift")
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var drift_min_rot_speed: float = 2.0
@export_range(0.5, 4.0, 0.1, "or_greater", "or_less") var drift_transition_rot_amount: float = 0.5
@export_range(0.0, 1.0, 0.01, "or_greater", "or_less") var drift_extra_rot_amount: float = PI/2
@export_range(0.0, 10.0, 0.01, "or_greater", "or_less") var drift_extra_rot_lerp: float = 2.5
@export_range(150, 450, 1, "or_greater", "or_less") var drift_min_forward_speed: float = 240.0
@export_range(150, 500, 1, "or_greater", "or_less") var drift_max_speed: float = 320.0
@export_range(3.0, 8.0, 0.1, "or_greater", "or_less") var drift_friction_deceleration: float = 6.0

var _perpendicular_vel_amount: float = 0.0

class DriftData:
	var extra_rot := 0.0
	var perpendicular_velocity := Vector2.ZERO
	
	func _init(extra_rot: float, perpendicular_velocity: Vector2) -> void:
		if extra_rot is float:
			self.extra_rot = extra_rot
		if perpendicular_velocity.x is float and perpendicular_velocity.y is float:
			self.perpendicular_velocity = perpendicular_velocity

func drift(delta: float) -> DriftData:
	# don't if reversing
	if _forwards_lerp_vel < 0:
		return DriftData.new(0, Vector2.ZERO)
	
	
	# calculate extra bit of angle to make the bus actually look like it's drifting
	
	var extra_rot_percent: float = clamp((abs(_rotation_vel) - (drift_min_rot_speed - drift_transition_rot_amount)) / (drift_min_rot_speed - drift_transition_rot_amount), 0.0, 1.0)
	# the amount (in the correct direction)
	var extra_rot_amount: float = extra_rot_percent * drift_extra_rot_amount * (_rotation_vel/abs(_rotation_vel))
	# prevent NaN
	if extra_rot_percent <= 0.2:
		extra_rot_amount = 0
	
	
	# only if going fast enough
	if abs(_rotation_vel) > drift_min_rot_speed and abs(_forwards_lerp_vel) > drift_min_forward_speed:
		var magic_math: float = (abs(_rotation_vel) - (drift_min_rot_speed)) * (_rotation_vel/abs(_rotation_vel)) / (turning_speed - (drift_min_rot_speed))
		
		_perpendicular_vel_amount = clampf(magic_math, -1, 1)
		
	else:
		_perpendicular_vel_amount = 0
	
	var drift_perpendicular_velocity := transform.y * (-_perpendicular_vel_amount * drift_max_speed)
	
	return DriftData.new(extra_rot_amount, drift_perpendicular_velocity)


#endregion

#region camera

@export_group("Camera", "camera")
## the camera zoom when going at max speed / any speed above `zoomed out speed`.
@export_range(0.5, 1.5, 0.1, "or_greater", "or_less") var camera_zoomed_out: float = 2.6
## the camera zoom when not moving / any speed below `zoomed in speed`.
@export_range(0.5, 1.5, 0.1, "or_greater", "or_less") var camera_zoomed_in: float = 3.0

## the speed where the camera starts zooming out.  Any speeds above this will have the camera transitioning between zoomed in & out, any speeds below this will be locked to the zoomed in camera zoom
@export_range(100, 600, 1, "or_greater", "or_less") var camera_zoomed_in_speed: float = 220.0
## the speed where the camera starts zooming in.  Any speeds below this will have the camera transitioning between zoomed in & out, any speeds above this will be locked to the zoomed out camera zoom
@export_range(100, 600, 1, "or_greater", "or_less") var camera_zoomed_out_speed: float = 300.0

func camera_movement(delta: float):
	
	var camera_zoom_percent: float = clampf((abs(_forwards_lerp_vel) - camera_zoomed_in_speed) / camera_zoomed_out_speed, 0, 1)
	
	var camera_zoom_amount: float = camera_zoomed_in - (camera_zoomed_in - camera_zoomed_out) * camera_zoom_percent

	camera.zoom = Vector2.ONE * camera_zoom_amount

#endregion

func _physics_process(delta: float) -> void:
	var _vel = movement(delta)
	var _rot := steer(delta)
	var _drift_vel_and_dir := drift(delta)
	
	# make the camera not follow the drift horizontal velocity
	camera.offset = _drift_vel_and_dir.perpendicular_velocity * delta
	
	camera_movement(delta)
	
	# make the sprite turn extra in drifts
	print(_drift_vel_and_dir.extra_rot)
	sprite.rotation = lerpf(sprite.rotation, PI/2 + _drift_vel_and_dir.extra_rot, delta * drift_extra_rot_lerp)
	
	rotation += _rot
	velocity = _vel
	move_and_slide()
	
	prev_rotation = rotation
