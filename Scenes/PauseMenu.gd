extends ColorRect

@onready var animPlayer : AnimationPlayer =  $AnimationPlayer
@onready var resButton : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var menuButton : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MenuButton



func unpause():
	animPlayer.play("Unpause")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	get_tree().paused = false
	

func pause():
	visible = true
	animPlayer.play("Pause")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused=true
	


func _on_resume_button_pressed():
	visible= false
	unpause()
	pass # Replace with function body.


func _on_menu_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
