extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.get_player().possessing and Game.get_player().possessing.is_in_group("headstone"):
		$Tween.interpolate_property(self, "global_position",
			global_position, Game.get_player().global_position + ((get_global_mouse_position()-Game.get_player().global_position).normalized()*clamp(Game.get_player().global_position.distance_to(get_global_mouse_position()),0,320)), 4,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property(self, "global_position",
			global_position, Game.get_player().global_position + ((get_global_mouse_position()-Game.get_player().global_position).normalized()*clamp(Game.get_player().global_position.distance_to(get_global_mouse_position()),0,80)), 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	pass
