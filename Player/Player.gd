extends CharacterBody3D

var spawner = null
const SENSITIVITY : float = 0.01
const SPEED : float = 5.5
const JUMP_VELOCITY : float = 7.0
const HITSTAGGER : float = 8.0 
const DASH :int = 200
const UPDASH : int = 50

var direction
var headDir
var maxDash : int = 0
var canDash :int =0
var spread : int = 10
var reloaded : bool = true
var maxLeaps : int = 0
var leapsQuant : int = 0
var maxPlatform : bool = true
var canFreeze : bool = true
var freezeUnlock : bool =true

const MAXHP : int = 50
var playerHealth :int = MAXHP
var canHurt :bool = true
var score :int = 0
var freezeVel : Vector3 
var frozen : bool = false
var canPlatform : bool = true
var seeSecrets : bool = false


@onready var shotgun = $Head/Camera3D/ShotGun
@onready var head = $Head
@onready var camera : Camera3D = $Head/Camera3D
@onready var bullet = preload("res://Player/Bullet.tscn")
@onready var platform = preload("res://Player/Platform.tscn")
@onready var animPlayer : AnimationPlayer =  $Head/Camera3D/ShotGun/AnimationPlayer


var hOffSet : float
var vOffSet : float

var gravity : float = 9.8
var fov : int =85



signal player_hit
signal player_died

func _ready():
	self.player_died.connect(get_parent()._on_player_player_died)
	self.player_hit.connect(get_parent()._on_player_player_hit)
	maxDash = get_node("/root/Level1").maxDash
	maxLeaps = get_node("/root/Level1").maxLeap
	maxPlatform =  get_node("/root/Level1").maxPlatform
	canFreeze = get_node("/root/Level1").canFreeze
	freezeUnlock = get_node("/root/Level1").freezeUnlock

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = fov
	randomize()	
	$Control/Health.max_value = MAXHP
	set_health_bar()
	$Audios/FreezeRumbke.set_stream_paused(true)

func set_health_bar():
	if playerHealth > MAXHP:
		playerHealth = MAXHP
	
	if playerHealth <=0 && get_parent() == get_node("/root/Level1"):
		queue_free()
	elif playerHealth <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused=true
		$Control/ColorRect/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Label.text = "You Died! 
		" + str(score)
		$Control/ColorRect.visible = true
	$Control/Health.value = playerHealth




func playerDied():
	emit_signal("player_died")

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		#shotgun.rotate_x(-event.relative.y * SENSITIVITY)
		#shotgun.rotation.x = clamp(shotgun.rotation.x, deg_to_rad(-58), deg_to_rad(58))
	
	
func Hit(dir, damage):
	if canHurt: 
		emit_signal("player_hit")
		playerHealth -= damage
		set_health_bar()
		canHurt = false
		$HurtTimer.start()
	velocity += dir * HITSTAGGER * damage


func _physics_process(delta):
	if Input.is_action_just_pressed("freeze") && !is_on_floor() && canFreeze:
		freeze()
	if Input.is_action_just_released("freeze"):
		if freezeUnlock:
			UnfreezePlus()
		else:
			unfreeze()

		
	#if Input.is_action_just_pressed("secrets") && seeSecrets == true:
	#	secretsOn()
	
	#if Input.is_action_just_pressed("secrets") && seeSecrets == false:
	#	secretsOff()
		
	if Input.is_action_just_pressed("shoot") && reloaded == true:
		shootGun()
		
	
	if Input.is_action_just_pressed("platform") && canPlatform && maxPlatform:
		Platform()
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("jump") and !is_on_floor() && !frozen:
		Leap(delta)

	if frozen:
		screenShake(randf_range(.05, -.05), randf_range(.05, -.05))
		$Head/Camera3D/Aim.visible = false
	# Get the input direction and handle the movement/deceleration.

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	headDir = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		$Audios/Dash.stop()
		canDash =  maxDash
		leapsQuant = maxLeaps 
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if Input.is_action_just_pressed("dash") :
				Dash(delta)
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7)
	if !is_on_floor() && !frozen:
		velocity.y -= gravity * delta
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3)
		if Input.is_action_just_pressed("dash") && canDash > 0:
				Dash(delta)
	if !is_on_floor() && frozen:
		if Input.is_action_just_pressed("dash") && canDash > 0:
				dashUnfreeze()
				Dash(delta)
				
	move_and_slide()

func shootGun():
	reloaded = false
	#screenShakeOff()
	$Audios/Shotgun.play()
	$Reload.start()
	animPlayer.play("Reload")
	for r in $Head/Camera3D/ShotGun/rayContainer.get_children(): 
		var b = bullet.instantiate()
		r.add_child(b)
		r.target_position.x = randf_range(spread, -spread)
		r.target_position.y = randf_range(spread, -spread)
		b.look_at((r.get_collision_point()))
		b.shoot = true
	if frozen:
		unfreeze()

func Dash(delta):
	if canDash > 0:
		$Audios/Dash.play()
		canDash -=1
		velocity.x = lerp(velocity.x, direction.x * DASH, delta *7)
		velocity.z = lerp(velocity.z, direction.z * DASH, delta *7)
		velocity.y = lerp(velocity.y, (headDir.y * UPDASH) + 10, delta *7)

func Leap(_delta):
	if leapsQuant > 0:
		$Audios/Dash.play()
		if velocity.y >= 0:
			velocity.y += 6
		else:
			velocity.y = 7
		leapsQuant  -=1
		#velocity.y = lerp(velocity.y, 200.0 , delta *5)

func _on_reload_timeout():
	reloaded = true

func screenShakeDur(quant, quant2, dur):
	camera.set_h_offset(quant)
	camera.set_v_offset(quant2)
	$Head/Camera3D/Aim.visible = false
	await get_tree().create_timer(dur).timeout
	screenShakeOff()


func screenShake(quant, quant2):
	camera.set_h_offset(quant)
	camera.set_v_offset(quant2)



func screenShakeOff():
	camera.set_h_offset(0)
	camera.set_v_offset(0)
	$Head/Camera3D/Aim.visible = true


func freeze():
	freezeVel = velocity
	velocity = Vector3(0,0,0)
	frozen = true
	$Audios/FreezeRumbke.set_stream_paused(false)


func unfreeze():
	if frozen:
		velocity = freezeVel
		freezeVel = Vector3(0,0,0) 
	frozen = false
	$Audios/FreezeRumbke.set_stream_paused(true)
	screenShakeOff()


func UnfreezePlus():
	if frozen:
		freezeVel = Vector3(0,0,0) 
		velocity = Vector3(50*direction.x,25* headDir.y,50*direction.z)

		#velocity.x =  50*direction
		#velocity.z =  50*direction
		#velocity.y = 10* headDir
		velocity.normalized()
		move_and_slide()
	frozen = false
	$Audios/FreezeRumbke.set_stream_paused(true)
	screenShakeOff()
	pass


func dashUnfreeze():
	freezeVel = Vector3(0,0,0) 
	frozen = false
	$Audios/FreezeRumbke.set_stream_paused(true)
	screenShakeOff()
	


func Platform():
	#make platform
	var p = platform.instantiate()
	#move platform to self
	p.global_transform = $Head/Camera3D/Aim/PlatformSpawner.global_transform
	#Make platform child of toplevel
	get_node("/root/Level1").add_child(p)
	#change platform rotation to face player facing 
	p.look_at(Vector3($Head/Camera3D/ShotGun/rayContainer/RayCast3D.get_collision_point().x, p.position.y, $Head/Camera3D/ShotGun/rayContainer/RayCast3D.get_collision_point().z), Vector3.UP)

	p.shoot = true
	
	#get platform rotation
	#var newDirection = (global_transform.basis * Vector3(1,1,1)).normalized()
	#add velocity? this doesn't work
	
	#p.velocity.z = 2.0 * newDirection.z
	#p.velocity.x = 2.0 * newDirection.x
	#direction = position.direction_to(position + velocity)
	#player controller stuff
	canPlatform = false
	$PlatformTimer.start()


func secretsOn():
	seeSecrets = true
	var enemyRecolour = get_tree().get_nodes_in_group("enemies") 
	for i in enemyRecolour:
		enemyRecolour.set_surface_override_material ( 1,  "res://LinearEnemies/Materials/Bonfire.tres")
	pass

func secretsOff():
	seeSecrets = false
	var enemyRecolour = get_tree().get_nodes_in_group("enemies") 
	for i in enemyRecolour:
		i.set_surface_override_material ( 1,  null)
	
	pass

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	


func _on_retry_button_pressed():
	get_tree().paused=false
	$Control/ColorRect.visible = false
	emit_signal("player_died")

	



func _on_hurt_timer_timeout():
	canHurt = true

func _on_platform_timer_timeout():
	canPlatform = true

