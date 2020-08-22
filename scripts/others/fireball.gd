extends Area2D


# Declare member variables here. Examples:
var speed = 5
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
	if body == Game.get_player():
		if Game.get_player().possessing and not Game.get_player().possessing.is_in_group("headstone"):
			Game.get_player().depossess()
		elif not Game.get_player().possessing:
			get_tree().change_scene("res://scenes/levels/menu.tscn")
	queue_free()
#	if body.name != dadName and not body.is_in_group("priest"):
#		if body.is_in_group("vessel") and body.state == Game.POSSESSED:
#			Game.get_player().depossess()
#		elif body == Game.get_player():
#			get_tree().change_scene("res://scenes/levels/menu.tscn")
#		queue_free()
	pass # Replace with function body.
