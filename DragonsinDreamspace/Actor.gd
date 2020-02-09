extends KinematicBody

export var locked = false
export var mouse_sensitivity = 15.0
export var FOV = 70.0
export var gravity = 30.0
export var speed = 10
export var acceleration = 8
export var deacceleration = 10
export var jump_height = 10

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
	
# Input
	direction = Vector3()
	var aim = get_global_transform().basis
	if Input.is_action_pressed("ui_up"):
		direction -= aim.z
	if Input.is_action_pressed("ui_down"):
		direction += aim.z
	if Input.is_action_pressed("ui_left"):
		direction -= aim.x
	if Input.is_action_pressed("ui_right"):
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	# Jump
	if is_on_floor():
		snap = Vector3(0, -1, 0)
		if Input.is_action_just_pressed("ui_select"):
			snap = Vector3(0, 0, 0)
			velocity.y = jump_height
	
	# Apply Gravity
	velocity.y += -gravity * delta
	
	# Acceleration and Deacceleration
	# where would the player go
	var temp_vel = Vector3()
	temp_vel.y = 0
	var target = direction * speed
	var temp_accel = 0
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration 
	else:
		temp_accel = deacceleration
	# interpolation
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	# clamping
	if direction.dot(velocity) == 0:
		if velocity.x < VELOCITY_CLAMP && velocity.x > -VELOCITY_CLAMP:
			velocity.x = 0
		if velocity.z < VELOCITY_CLAMP && velocity.z > -VELOCITY_CLAMP:
			velocity.z = 0
	
	# Move
	velocity.y = move_and_slide_with_snap(velocity, snap, floor_normal, true, 4, deg2rad(floor_max_angle)).y


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


func go_GUI():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	locked = true

func end_GUI():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	locked = false
	
func flattenView():
	temp = $Head.rotation_degrees
	temp.x = 0
	$Head.rotation_degrees = temp
