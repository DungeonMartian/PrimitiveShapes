extends CharacterBody3D


const speed = 5.0
const accel = 10
var player 
var direction = Vector3(0, 0, 0)


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var playerPos:NodePath
@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _ready():
	player = get_node(playerPos)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	nav.set_velocity(new_velocity)

func update_target_location(target_location):
	nav.target_position = target_location

#func _on_calc_path_timeout():
	direction = Vector3()
	nav.target_position = get_node(playerPos).position
	direction = direction.normalized()
	
	
	
	pass # Replace with function body.


func _on_navigation_agent_3d_target_reached():
	var dir = global_position.direction_to(player.global_position)
	player.Hit(dir)
	
	pass # Replace with function body.


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

