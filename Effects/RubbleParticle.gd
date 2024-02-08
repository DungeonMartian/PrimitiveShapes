extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
