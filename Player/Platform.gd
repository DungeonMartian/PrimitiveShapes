extends CharacterBody3D
var direction 
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = global_transform.basis * Vector3(1,1,1).normalized()
	#direction = position.direction_to(position + velocity)
	
	
	velocity.y = 0

	#print(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	set_as_top_level(true)
	#velocity.x = velocity.x 
	#velocity.z = velocity.z * direction.z 


	move_and_slide()



func _on_timer_timeout():
	queue_free()
