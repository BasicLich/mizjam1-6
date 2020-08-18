extends Area2D


# Declare member variables here. Examples:
var speed = 10
var dadName

# Called when the node enters the scene tree for the first time.
func _ready():
	$Position2D.position = $Position2D.position * speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = $Position2D.global_position
	pass


func _on_fireball_body_entered(body):
	if body.name != dadName and not body.is_in_group("mage"):
		queue_free()
	pass # Replace with function body.
