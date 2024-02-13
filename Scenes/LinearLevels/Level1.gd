extends Node3D

var player
@onready var hit_rect = $UI/HitRect
var spawner = null
var combat : bool = false

var maxDash : int =1
var maxLeap : int=2
var maxPlatform : bool = false
var canFreeze : bool = false
var freezeUnlock : bool = false

func _ready():
	randomize()
	
	

func _physics_process(_delta):
	#print(Engine.get_frames_per_second())
	if !player == null:
		get_tree().call_group("enemies", "update_target_location", player.global_position)
	if Input.is_action_just_pressed("pause"):
		$UI/PauseMenu.pause()
	
	if combat == true:
		if !$Audio/Music.is_playing():
			$Audio/Music.set_volume_db(-2)
			$Audio/Music.play()
	
	if Input.is_action_just_pressed("devUnlock"):
		devUnlock()

	
func devUnlock():
	maxDash +=3
	maxLeap += 3
	maxPlatform = true
	canFreeze = true
	freezeUnlock = true
	pass


func _on_player_player_died():
	player.queue_free()
	#get_tree().reload_current_scene()


func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible= false
	




func _on_enemy_combat():
	combat = true
	$Audio/CombatTimerout.start(2)
	$Audio/PeaceTimer.stop()

	


func _on_peace_timer_timeout():
	$Audio/Music.stop()
	


func _on_combat_timerout_timeout():
	combat = false
	$Audio/PeaceTimer.start(3)






func _on_disable_timeout():
	$UI/Helper.visible = false
