extends RigidBody3D

var shoot = false
var damage = 1
@onready var spawnEffect = preload ("res://Effects/RubbleParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shoot:
		apply_impulse(-transform.basis.z, -transform.basis.z)
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("enemies"):
		body.health -= damage
		#var b = spawnEffect.instantiate()
		#add_child(b)
		queue_free()
	elif body.is_in_group("player"):
		pass
	else:
		#var b = spawnEffect.instantiate()
		#add_child(b)
		#b.position = position
		#remove_child(b)
		queue_free()
