extends Node3D

@onready var player = $Player
@onready var hit_rect = $UI/HitRect
@onready var spawns = $SpawnController
@onready var navRegion = $NavigationRegion3D


var enemy = preload("res://Enemies/Enemy.tscn")

const JUMP_VELOCITY = 7.0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible= false
	
	pass # Replace with function body.

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

	
func startWave():
	var spawn_point = _get_random_child(spawns).global_position
	var instance = enemy.instantiate()
	instance.position = spawn_point
	navRegion.add_child(instance)

	
func _on_timer_timeout():
	startWave()




func _on_update_player_pos_timeout():
	get_tree().call_group("enemies", "update_target_location", $Player.global_transform.origin)

