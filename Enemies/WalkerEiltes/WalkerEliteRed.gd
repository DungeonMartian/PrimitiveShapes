extends CharacterBody3D

var player 
var dir = Vector3(0, 0, 0)

var curPosx
var newPosx
var curPosz
var newPosz

var canJump
var dying = false

var JUMP_VELOCITY = 8.0 
var gravity =12
var damage = 5
var health = 5
var speed = 6.0


#@export var playerPos:NodePath
@export var playerPos:= "../../Player"
@onready var nav: NavigationAgent3D = $NavigationAgent3D



func _ready():
	player = get_node(playerPos)


func _physics_process(delta):
	# Add the gravity.
	if health <=0 && !dying:
		rotation.z = lerp(rotation.z, randf_range(60,180),  delta/25)
		die()
	if !dying:
		pass
	if dying && !is_on_floor():
		velocity. y -= gravity
	


func update_target_location(target_location):
	nav.target_position = target_location
	
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	new_velocity = Vector3i(new_velocity.x ,-gravity, new_velocity.z)
	nav.set_velocity(new_velocity)
	
		
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z ))
	if is_on_floor():
		if player.global_position.y-2 > global_position.y && canJump:
			tryJump()
		canJump = true
		$jumpTimer.paused = false

func die():
	dying = true
	player.score += 200
	await get_tree().create_timer(0.4).timeout
	queue_free()



func _on_navigation_agent_3d_target_reached():
	dir = global_position.direction_to(player.global_position)
	player.Hit(dir, damage)
	



func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if !dying:
		velocity = velocity.move_toward(safe_velocity, .5)
		move_and_slide()

func tryJump():
	velocity = 20 * global_position.direction_to(player.global_position)
	velocity.y = JUMP_VELOCITY
	canJump = false
	await get_tree().create_timer(0.2).timeout
	
	
	pass


func _on_jump_timer_timeout():
	if !dying:
		newPosx = curPosx
		newPosz = curPosz
		curPosx = round(global_position.x)
		curPosz = round(global_position.z)
		if (newPosx == curPosx) && (newPosz == curPosz) && canJump:
			tryJump()
			$jumpTimer.paused = true
	
