extends Node3D

var FADEOUT

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	if FADEOUT:
			$Audio/Music.set_volume_db(lerpf($Audio/Music.get_volume_db(), -30.0, delta))


func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_resume_button_pressed():
	FADEOUT = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
	pass # Replace with function body.


func _on_play_button_pressed():
	FADEOUT = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/LinearLevels/Level1.tscn")
	pass # Replace with function body.
