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
var reloaded = true

const MAXHP = 50
var playerHealth = MAXHP
var score = 0


@onready var shotgun = $Head/ShotGun
@onready var head = $Head
@onready var camera : Camera3D = $Head/Camera3D
@onready var bullet = preload("res://Player/Bullet.tscn")


var gravity = 9.8
var fov =85

signal player_hit
signal player_died

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = fov
	randomize()	
	$Control/Health.max_value = MAXHP
	set_health_bar()

func set_health_bar():
	if playerHealth > MAXHP:
		playerHealth = MAXHP
	if playerHealth < 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused=true
		$Control/ColorRect/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Label.text = "You Died! 
		" + str(score)
		$Control/ColorRect.visible = true
	$Control/Health.value = playerHealth

func shootGun():
	reloaded = false
	$Audios/Shotgun.play()
	$Reload.start()
	for r in shotgun.get_children(): 
		var b = bullet.instantiate()
		r.add_child(b)
		r.target_position.x = randf_range(spread, -spread)
		r.target_position.y = randf_range(spread, -spread)
		b.look_at((r.get_collision_point()))
		b.shoot = true


func playerDied():
	emit_signal("player_died")

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		shotgun.rotate_x(-event.relative.y * SENSITIVITY)
		shotgun.rotation.x = clamp(camera.rotation.x, deg_to_rad(-61), deg_to_rad(59))
	
	
func Hit(dir, damage):
	emit_signal("player_hit")
	playerHealth -= damage
	set_health_bar()
	velocity += dir * HITSTAGGER
	pass
		
func _physics_process(delta):
	
		
	if Input.is_action_just_pressed("shoot") && reloaded == true:
		shootGun()
		
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	headDir = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		$Audios/Dash.stop()
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
		$Audios/Dash.play()
		canDash -=1
		velocity.x = lerp(velocity.x, direction.x * DASH, delta *7)
		velocity.z = lerp(velocity.z, direction.z * DASH, delta *7)
		velocity.y = lerp(velocity.y, (headDir.y * UPDASH) + 10, delta *7)


func _on_reload_timeout():
	reloaded = true
	pass # Replace with function body.






func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.


func _on_retry_button_pressed():
	get_tree().paused=false
	$Control/ColorRect.visible = false
	emit_signal("player_died")
	pass # Replace with function body.
