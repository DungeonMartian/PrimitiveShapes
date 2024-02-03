extends Node3D


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		#body.spawner.position = Vector3(position.x, position.y+2, position.z)
		body.spawner.position = position
		body.playerHealth = body.MAXHP
		body.set_health_bar()
