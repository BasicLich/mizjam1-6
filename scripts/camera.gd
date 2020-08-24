extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Pause.visible = false
	$CenterContainer/Died.visible = false
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
	
	if Input.is_action_just_pressed("esc"):
		$CenterContainer/Pause.visible = true
		get_tree().paused = true
	pass

func player_die():
	get_tree().paused = true
	$CenterContainer/Died.visible = true
	pass


func _on_Button_button_up():
	get_tree().paused = false
	$CenterContainer/Pause.visible = false
	pass # Replace with function body.


func _on_Button_mouse_entered():
	$CenterContainer/Pause/AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_Button2_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_Button2_mouse_entered():
	$CenterContainer/Pause/AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_Button3_button_up():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/levels/menu.tscn")
	pass # Replace with function body.


func _on_Button3_mouse_entered():
	$CenterContainer/Pause/AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_Button4_button_up():
	get_tree().paused = false
	get_tree().quit()
	pass # Replace with function body.


func _on_Button4_mouse_entered():
	$CenterContainer/Pause/AudioStreamPlayer.play()
	pass # Replace with function body.
