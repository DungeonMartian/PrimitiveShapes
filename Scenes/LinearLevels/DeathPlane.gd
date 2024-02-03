extends Area3D





func _on_body_entered(body):
	if body.is_in_group("player"):
		body.playerHealth -= 1000
		body.set_health_bar()
	else:
		body.queue_free()


