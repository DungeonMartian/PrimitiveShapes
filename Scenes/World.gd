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

var max_enemies : int = 30
# key is enemy prefab, item is boolean indicating whether it has executed yet
var enemies : Dictionary = {}

const JUMP_VELOCITY = 7.0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		$UI/PauseMenu.pause()
	var all_finished = true;
	for enemy in enemies.keys():
		if enemy == null:
			enemies.erase(enemy)
			continue
		
		if (enemies[enemy]):
			continue
		else:
			if enemy.has_method("update_target_location"):
				enemy.update_target_location($Player.global_transform.origin)
			enemies[enemy] = true
			all_finished = false
			break
	if all_finished:
		for enemy in enemies.keys():
			enemies[enemy] = false


func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible= false
	
	pass # Replace with function body.

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

	
func startWave():
	player.playerHealth +=20
	player.set_health_bar()
	#difficulty = wave number
	print("wave quant "+ str(waveQuant))

	if (difficulty%3) == 0:
		waveQuant+=1
		

	if difficulty > 3:
		for n in range(0,waveQuant/2):
			eliteNum = n
			
	fixedWaveQuant = waveQuant - eliteNum
			
	for n in (fixedWaveQuant):
		if enemies.size() > max_enemies: break
		var spawn_point = _get_random_child(spawns).global_position
		instance = enemy.instantiate()
		instance.position = spawn_point
		
		navRegion.add_child(instance)
		enemies[instance] = false
		
	for n in (eliteNum):
		if enemies.size() > max_enemies: break
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
		enemies[instance] = false




func _on_update_player_pos_timeout():
	pass
	#get_tree().call_group("enemies", "update_target_location", $Player.global_transform.origin)



func _on_spawn_enemies_timeout():
		startWave()
		if $Audio/Music.playing == false:
			$Audio/Music.play()
		difficulty +=1



func _on_player_player_died():
	get_tree().reload_current_scene()
	pass # Replace with function body.
