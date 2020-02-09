extends KinematicBody

export var locked = false
export var mouse_sensitivity = 15.0
export var FOV = 70.0
export var gravity = 30.0
export var speed = 10
export var acceleration = 8
export var deacceleration = 10
export var jump_height = 10
export var fly_speed = 10
export var fly_accel = 4
var flying = false


var velocity = Vector3()
var direction = Vector3()
const floor_normal = Vector3(0,1,0)
export var floor_max_angle = 45.0
const VELOCITY_CLAMP = 0.25

var axis = Vector2()
var temp = Vector3()
var snap = Vector3()
var x
var y

func _ready():
	$Head/Camera.fov = FOV
	if locked:
		return
	$Head/Camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if locked:
		return
	rotate_camera(delta)
	
	direction = Vector3()
	var aim = $Head.get_global_transform().basis
	if Input.is_action_pressed("ui_up"):
		direction -= aim.z
	if Input.is_action_pressed("ui_down"):
		direction += aim.z
	if Input.is_action_pressed("ui_left"):
		direction -= aim.x
	if Input.is_action_pressed("ui_right"):
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target = direction * fly_speed
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)

func _input(event):
	if event is InputEventMouseMotion:
		axis = event.relative

func rotate_camera(delta):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if axis.length() > 0:
		x = -axis.x * mouse_sensitivity * delta
		y = -axis.y * mouse_sensitivity * delta
		axis = Vector2() #Zero axis to prevent issues
		rotate_y(deg2rad(x))
		$Head.rotate_x(deg2rad((y)))
	
		temp = $Head.rotation_degrees
		temp.x = clamp(temp.x, -90, 90)
		$Head.rotation_degrees = temp
