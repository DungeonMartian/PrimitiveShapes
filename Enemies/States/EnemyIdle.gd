extends State
class_name EnemyIdle

@export var enemy: CharacterBody3D
@export var move_speed : = 5

var move_direction : Vector3
var wander_timer : float

var player : CharacterBody3D

func randomize_wander():
	move_direction = Vector3(randf_range(-1,1),0,randf_range(-1,1)).normalized()
	wander_timer = randf_range(1,3)


func Enter():
	randomize_wander()
	player = get_tree().get_first_node_in_group("player")
	
func state_process(delta: float):
	if wander_timer > 0: 
		wander_timer -= delta
	else:
		randomize_wander()
		
func state_physics_process(delta: float):
	if enemy:
		enemy.velocity= move_direction*move_speed
	
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < 10:
		Transitioned.emit(self, "Follow")
