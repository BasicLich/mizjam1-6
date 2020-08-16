extends Node


# Declare member variables here. Examples:
enum {
	IDLE,
	CURIOUS,
	SCARED,
	ANGRY,
	DIZZY,
	POSSESSED
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_main():
	return get_tree().current_scene


func get_player():
	return get_main().get_node("player")
