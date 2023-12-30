extends CharacterBody3D

const SENSITIVITY = 0.01
const SPEED = 5.5
const JUMP_VELOCITY = 7.0
const HITSTAGGER = 8.0 
const DASH = 200
const UPDASH = 50

var direction
var headDir
var canDash =1 
var spread = 10

@onready var ray_container = $Head/RayContainer
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var bullet = preload("res://Player/Bullet.tscn")

var gravity = 9.8
var fov =85

signal player_hit

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = fov
	randomize()

func shootGun():
	for r in ray_container.get_children(): 
		var b = bullet.instantiate()
		r.add_child(b)
		r.target_position.x = randf_range(spread, -spread)
		r.target_position.y = randf_range(spread, -spread)
		b.look_at((r.get_collision_point()))
		b.shoot = true




func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-65), deg_to_rad(75))
		ray_container.rotate_x(-event.relative.y * SENSITIVITY)
		ray_container.rotation.x = clamp(camera.rotation.x, deg_to_rad(-65), deg_to_rad(75))
	
	
func Hit(dir):
	emit_signal("player_hit")
	velocity += dir * HITSTAGGER
	pass
		
func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		shootGun()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	headDir = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		canDash = 1
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if Input.is_action_just_pressed("dash") :
				Dash(delta)
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7)
	if !is_on_floor():
		velocity.y -= gravity * delta
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3)
		if Input.is_action_just_pressed("dash") :
				Dash(delta)
	move_and_slide()

func Dash(delta):
	if canDash > 0:
		canDash -=1
		velocity.x = lerp(velocity.x, direction.x * DASH, delta *7)
		velocity.z = lerp(velocity.z, direction.z * DASH, delta *7)
		velocity.y = lerp(velocity.y, (headDir.y * UPDASH) + 10, delta *7)
