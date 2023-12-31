extends Node3D


# Called when the node enters the scene tree for the first time.



func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_resume_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
	pass # Replace with function body.
