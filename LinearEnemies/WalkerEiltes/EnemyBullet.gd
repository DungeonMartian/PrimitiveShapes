extends RigidBody3D

@onready var spawnEffect = preload ("res://Effects/RubbleParticle.tscn")
var shoot : bool = false
var damage : int = 10
var dir
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var g = spawnEffect.instantiate()
		get_node("/root/Level1").add_child(g)
		g.global_transform = global_transform
		g.set_emitting(true)
		dir = global_position.direction_to(body.global_position)
		body.Hit(-dir, damage)
		#remove_child(g)
		self.queue_free()
	elif body.is_in_group("enemies"):
		pass
	else:
		var g = spawnEffect.instantiate()
		get_node("/root/Level1").add_child(g)
		g.global_transform = global_transform
		g.set_emitting(true)
		self.queue_free()
	pass # Replace with function body.


func _on_launch_timeout():
	apply_impulse(-transform.basis.z, -transform.basis.z)

