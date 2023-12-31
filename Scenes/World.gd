extends Node3D

@onready var player = $Player
@onready var hit_rect = $UI/HitRect
@onready var spawns = $SpawnController
@onready var navRegion = $NavigationRegion3D


var enemy = preload("res://Enemies/Enemy.tscn")
var enemyE1 = preload("res://Enemies/WalkerEiltes/WalkerEliteGreen.tscn")
var enemyE2 = preload("res://Enemies/WalkerEiltes/WalkerEliteLarge.tscn")
var enemyE3 = preload("res://Enemies/WalkerEiltes/WalkerEliteRed.tscn")

var instance 
var difficulty = 0
var waveQuant = 3
var spawnThisRound = 0	
var eliteNum = 0
var fixedWaveQuant = 0



const JUMP_VELOCITY = 7.0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		$UI/PauseMenu.pause()

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
	
	#difficulty = wave number
	print("wave quant "+ str(waveQuant))

	if (difficulty%3) == 0:
		waveQuant+=1
		

	if difficulty > 3:
		for n in range(0,waveQuant/2):
			eliteNum = n
			
	fixedWaveQuant = waveQuant - eliteNum
			
	for n in range(0,fixedWaveQuant):
		var spawn_point = _get_random_child(spawns).global_position
		instance = enemy.instantiate()
		instance.position = spawn_point
		navRegion.add_child(instance)
		
	for n in range(0,eliteNum):
		var spawn_point = _get_random_child(spawns).global_position
		
		print("spawned elite")
		
		#pick one of 3 random elite types
		
		var e = randi_range(0,2)
		if e == 0:
			instance = enemyE1.instantiate()
		elif e == 1:
			instance = enemyE2.instantiate()
		else:
			instance = enemyE3.instantiate()
		instance.position = spawn_point
		navRegion.add_child(instance)

	
	




func _on_update_player_pos_timeout():
	get_tree().call_group("enemies", "update_target_location", $Player.global_transform.origin)



func _on_spawn_enemies_timeout():
		startWave()
		difficulty +=1

