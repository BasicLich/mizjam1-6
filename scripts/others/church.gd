extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_priest():
	var priest = load("res://scenes/vessels/mage.tscn").instance()
	priest.global_position = global_position
	priest.state = Game.ANGRY
	priest.path = Game.get_main().get_node("Navigation2D").get_simple_path(priest.global_position, Game.get_player().global_position, false)
	Game.get_main().add_child(priest)
	pass
