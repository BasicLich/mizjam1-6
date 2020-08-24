extends Node2D


# Declare member variables here. Examples:
var id = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("church")
	pass # Replace with function body.


func spawn_priest(where):
	if visible:
		var priest = load("res://scenes/vessels/priest.tscn").instance()
		priest.global_position = global_position
		priest.path = Game.get_main().get_node("Navigation2D").get_simple_path(priest.global_position, Game.get_player().global_position, false)
		priest.name = priest.name + str(id)
		id += 1
		Game.get_main().add_child(priest)
		priest.get_curious(where)
	pass
