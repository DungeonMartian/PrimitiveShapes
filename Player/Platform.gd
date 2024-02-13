extends RigidBody3D
var direction 
var shoot :bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#direction = global_transform.basis * Vector3(1,1,1).normalized()
	#direction = position.direction_to(position + velocity)
	
	set_as_top_level(true)


	#print(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if shoot:		
		apply_impulse(-transform.basis.z, -transform.basis.z)
		shoot =  false

	#velocity.x = lerp(velocity.x,  direction.x, delta *3)
	#velocity.x = lerp(velocity.y,  direction.y, delta *3)




func _on_timer_timeout():
	queue_free()
