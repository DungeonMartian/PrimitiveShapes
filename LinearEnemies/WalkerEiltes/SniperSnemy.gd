extends CharacterBody3D


var dir = Vector3(0, 0, 0)

var target
const TURN_SPEED = 2

var dying :bool= false

var gravity :int =12
var damage :int= 2
var health :int= 5


var ATTACK : bool = false

@onready var raycast = $Eyes/Aim
@onready var eyes = $Eyes
@onready var shootTimer = $ShootTimer
@onready var bulletLocation = $BulletLocation
@onready var laster = $Eyes/Aim/MeshInstance3D

@onready var enemyBullet = preload("res://LinearEnemies/WalkerEiltes/EnemyBullet.tscn")

var direction : Vector3 = Vector3(100000,0,100000)
signal combat






func _ready():
	self.combat.connect(get_parent().get_parent().get_parent()._on_enemy_combat)
	#$Audio/EnemySpawn.play()


func _physics_process(delta):
	# Add the gravity.
	
	if health <=0 && !dying:
		rotation.z = lerp(rotation.z, randf_range(60,180),  delta/25)
		#sound goes off here
		die()
	if !dying:
		if is_on_floor():
			pass # sounds goes on here
		if !is_on_floor():
			pass #sound goes off here
	if dying && !is_on_floor():
		velocity.x = 0
		velocity.y  = lerpf(velocity.y, -gravity, .2)
		velocity.z = 0
		move_and_slide()
	if ATTACK == true && !dying:
		eyes.look_at(target.global_transform.origin, Vector3.UP)
		emit_signal("combat")
		rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
	

	if ATTACK == false:
		shootTimer.stop()
	move_and_slide()


func update_target_location(_asd):
	pass


func die():
	dying = true
	ATTACK = false
	shootTimer.stop()
	await get_tree().create_timer(0.4).timeout
	queue_free()


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		shootTimer.start()
		ATTACK = true
		target = body
		laster.visible = true


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		ATTACK = false
		laster.visible = false


func _on_shoot_timer_timeout():
	var b = enemyBullet.instantiate()
	bulletLocation.add_child(b)
	
	b.look_at(target.global_transform.origin + target.velocity, Vector3.UP)
	print("firing")

