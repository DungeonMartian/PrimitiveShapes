extends State
class_name EnemyFollow

@export var enemy: CharacterBody3D
@export var move_speed := 40
@onready var nav : NavigationAgent3D = $"../../NavigationAgent3D"
@export var player : CharacterBody3D


func Enter():
	pass


func Exit():
	pass

func _physics_process(delta):
	print("help")
	var direction = enemy.player.global_position - enemy.global_position
	if direction.length() > 12:
		Transitioned.emit(self, "Follow")
	#var direction = Vector3()
	#direction = nav.get_next_path_position() - enemy.global_position
	#direction = direction.normalized()
	#
	#enemy.velocity = enemy.velocity.lerp(direction * move_speed, 2 * delta)
	#
	var current_location = enemy.global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * enemy.speed
	new_velocity = Vector3i(new_velocity.x ,-enemy.gravity, new_velocity.z)
	nav.set_velocity(new_velocity)

	enemy.look_at(Vector3(enemy.player.global_position.x, enemy.global_position.y, enemy.player.global_position.z ))
	
	#
	#if enemy.is_on_floor():
		#if enemy.player.global_position.y - 3 > enemy.global_position.y && enemy.canJump :
			#enemy.tryJump()
		#enemy.canJump = true
		#$"../../jumpTimer".paused = false
	#


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if !enemy.dying:
		enemy.velocity = enemy.velocity.move_toward(safe_velocity, .5)
		enemy.move_and_slide()
