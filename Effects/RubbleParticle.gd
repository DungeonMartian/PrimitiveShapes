extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("fuckl")
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	get_parent().queue_free()
	print("fuck2")
	pass # Replace with function body.
