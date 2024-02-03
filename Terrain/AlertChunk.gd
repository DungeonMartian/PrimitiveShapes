extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		var containsEnemies = get_overlapping_bodies()
		for n in containsEnemies:
			if n.is_in_group("enemies"):
				n.Search = true
				n.player = body
		

		
	else:
		pass


func _on_body_exited(body):
	if body.is_in_group("player"):
		var containsEnemies = get_overlapping_bodies()
		for n in containsEnemies:
			if n.is_in_group("enemies"):
				n.Search = false
	pass # Replace with function body.
