extends StaticBody3D

var time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$CharacterBody3D.velocity = Vector3(0, get_sine(),0)
	$CharacterBody3D.move_and_slide()

func get_sine():
	return sin(time*1) *1

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.maxLeaps +=1
		get_node("/root/Level1").maxLeap+=1
		get_node("/root/Level1/UI/Helper").visible = true
		get_node("/root/Level1/UI/Helper").text = "Double Jump"
		get_node("/root/Level1/UI/Helper/Disable").start()
		queue_free()
