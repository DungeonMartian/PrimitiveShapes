extends Area3D


# Called when the node enters the scene tree for the first time.



func _on_body_entered(body):
	print("killed one")
	body.queue_free()
	pass # Replace with function body.
