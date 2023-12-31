extends ColorRect

@onready var animPlayer : AnimationPlayer =  $AnimationPlayer
@onready var resButton : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var menuButton : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MenuButton



func unpause():
	animPlayer.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	animPlayer.play("Pause")
	get_tree().paused=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_button_pressed():
	unpause()
	pass # Replace with function body.


func _on_menu_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
