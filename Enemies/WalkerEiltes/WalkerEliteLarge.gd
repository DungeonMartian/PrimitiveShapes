extends CharacterBody3D


var dir = Vector3(0, 0, 0)

var curPosx
var newPosx
var curPosz
var newPosz

var canJump
var dying = false

var JUMP_VELOCITY :float= 8.0 
var gravity :int =12
var damage :int= 3
var health :int= 30
var speed :float = 2.0



var ATTACK
var Search : bool = false

var direction : Vector3 = Vector3(100000,0,100000)
signal combat

#@export var playerPos:NodePath
@onready var player
@onready var nav: NavigationAgent3D = $NavigationAgent3D


func _ready():
	self.combat.connect(get_parent().get_parent().get_parent()._on_enemy_combat)
	#$Audio/EnemySpawn.play()


func _physics_process(delta):
	# Add the gravity.
	if health <=0 && !dying:
		rotation.z = lerp(rotation.z, randf_range(60,180),  delta/25)
		#sound goes off here
		die()
	if !dying:
		if is_on_floor():
			pass # sounds goes on here
		if !is_on_floor():
			pass #sound goes off here
	if dying && !is_on_floor():
		velocity.x = 0
		velocity.y  = lerpf(velocity.y, -gravity, .2)
		velocity.z = 0
		move_and_slide()
	if ATTACK == true && !dying:
		look_at(Vector3(nav.target_position.x, global_position.y, nav.target_position.z ))
		emit_signal("combat")

func update_player(newPlayer):
	player = newPlayer

func update_target_location(target_location):
	if Search || ATTACK:
		nav.target_position = target_location
		direction = Vector3(target_location.x, global_position.y, target_location.z ) - global_position

	
	if direction.length() > 1 && !Search:
		ATTACK = false
	if direction.length() < 30:
		ATTACK = true
	
	if ATTACK == true:
		
		
		var current_location = global_transform.origin
		var next_location = nav.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		new_velocity = Vector3(new_velocity.x ,-gravity, new_velocity.z)
		nav.set_velocity(new_velocity)
		
		
		

		if is_on_floor():
			if player.global_position.y  - 3 > global_position.y && canJump && player.is_on_floor() :
				tryJump()
				pass
			canJump = true
			$jumpTimer.paused = false

	

func die():
	dying = true
	ATTACK = false
	await get_tree().create_timer(0.4).timeout
	queue_free()




func _on_navigation_agent_3d_target_reached():
	dir = global_position.direction_to(player.global_position)
	player.Hit(dir, damage)
	$Audio/HitPlayer.play()
	



func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if ATTACK == true:
		if !dying:
			velocity = velocity.move_toward(safe_velocity, .5)
			move_and_slide()

			
	if ATTACK == false:
		velocity.x = 0
		velocity.y  = lerpf(velocity.y, -gravity, .2)
		velocity.z = 0


	move_and_slide()

func tryJump():
	await get_tree().create_timer(randf_range(0,1)).timeout
	if !player == null:
		velocity = 20 * global_position.direction_to(player.global_position)
		velocity.y = JUMP_VELOCITY
	canJump = false
	await get_tree().create_timer(0.2).timeout
	
	



func _on_jump_timer_timeout():
	if !dying:
		newPosx = curPosx
		newPosz = curPosz
		curPosx = round(global_position.x)
		curPosz = round(global_position.z)
		if (newPosx == curPosx) && (newPosz == curPosz) && canJump:
			tryJump()
			$jumpTimer.paused = true
	
