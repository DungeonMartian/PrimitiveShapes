extends StaticBody3D



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	#$CharacterBody3D.position = Vector3(position.x + randf_range(-.5, .5) , position.y + randf_range(-.5, .5) , position.z+ randf_range(-.5, .5) )

	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.canFreeze = true
		get_node("/root/Level1").canFreeze = true
		get_node("/root/Level1/UI/Helper").visible = true
		get_node("/root/Level1/UI/Helper").text = "Right Click to freeze mid air. Incomplete:"
		get_node("/root/Level1/UI/Helper/Disable").start()
		queue_free()
