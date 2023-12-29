extends CharacterBody3D

const SENSITIVITY = 0.01
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const HITSTAGGER = 8.0 
const DASH = 500
const UPDASH = 100

var direction
var headDir

@onready var head = $Head
@onready var camera = $Head/Camera3D

var gravity = 9.8

signal player_hit

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-65), deg_to_rad(75))

func Hit(dir):
	emit_signal("player_hit")
	velocity += dir * HITSTAGGER
	pass
		
func _physics_process(delta):
	if Input.is_action_just_pressed("dash") :
		velocity.x = lerp(velocity.x, direction.x * DASH, delta * 7)
		velocity.z = lerp(velocity.z, direction.z * DASH, delta * 7)
		if !is_on_floor():
			velocity.y = lerp(velocity.y, headDir.y * UPDASH, delta * 7)
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	headDir = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7)
	if !is_on_floor():
		velocity.y -= gravity * delta
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3)
	move_and_slide()
