extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	$button.play()
	$CenterContainer/Control.visible = false
	$CenterContainer/Control.focus_mode = 0
	$CenterContainer/Levels.visible = true
	$CenterContainer/Levels.focus_mode = 1
	pass # Replace with function body.


func _on_Button2_button_up():
	get_tree().quit()
	pass # Replace with function body.


func _on_Tutorial_button_up():
	get_tree().change_scene("res://scenes/levels/tutorial.tscn")
	pass # Replace with function body.


func _on_Level1_button_up():
	get_tree().change_scene("res://scenes/levels/level1.tscn")
	pass # Replace with function body.


func _on_Level2_button_up():
	get_tree().change_scene("res://scenes/levels/level2.tscn")
	pass # Replace with function body.


func _on_Level3_button_up():
	get_tree().change_scene("res://scenes/levels/level3.tscn")
	pass # Replace with function body.


func _on_Level4_button_up():
	get_tree().change_scene("res://scenes/levels/level4.tscn")
	pass # Replace with function body.


func _on_Level5_button_up():
	get_tree().change_scene("res://scenes/levels/level5.tscn")
	pass # Replace with function body.


func _on_Level6_button_up():
	get_tree().change_scene("res://scenes/levels/level6.tscn")
	pass # Replace with function body.


func _on_Button_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Button2_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Tutorial_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level1_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level2_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level3_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level4_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level5_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level6_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Infinite_button_up():
	get_tree().change_scene("res://scenes/levels/infinite.tscn")
	pass # Replace with function body.


func _on_Infinite_mouse_entered():
	$button.play()
	pass # Replace with function body.


func _on_Level7_button_up():
	get_tree().change_scene("res://scenes/levels/level7.tscn")
	pass # Replace with function body.


func _on_Level8_button_up():
	get_tree().change_scene("res://scenes/levels/level8.tscn")
	pass # Replace with function body.


func _on_Level9_button_up():
	get_tree().change_scene("res://scenes/levels/level9.tscn")
	pass # Replace with function body.
