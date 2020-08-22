extends StaticBody2D

var state = Game.SCARED

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("headstone")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state != Game.POSSESSED:
		if Game.get_player().possessing and Game.get_player().possessing.is_in_group("headstone") and get_global_mouse_position().x > global_position.x-15 and get_global_mouse_position().y > global_position.y-15 and get_global_mouse_position().x < global_position.x+15 and get_global_mouse_position().y < global_position.y+15:
			$CollisionShape2D/Sprite/Sprite2.modulate = Color(0,1,0)
			if Input.is_action_just_pressed("mouseL"):
				Game.get_player().depossess()
				Game.get_player().possess(self)
	pass
