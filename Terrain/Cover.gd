extends StaticBody3D
var health : int = 1
var dying : bool = false

var ATTACK
var Search
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if health <=0 :
		get_parent().queue_free()
		

	
