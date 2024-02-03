extends Node3D

var player_scene = preload("res://Player/Player.tscn")
var player = null




func _process(_delta):
	if player == null:
		var new_obj = player_scene.instantiate()
		player = new_obj
		new_obj.position = position
		new_obj.spawner = self
		get_tree().paused = false
		get_node("/root/Level1").add_child(new_obj)
		get_node("/root/Level1").player = new_obj
