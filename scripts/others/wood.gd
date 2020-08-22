extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("wood")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func remove():
	$CollisionShape2D/Sprite.visible = false
	$CollisionShape2D.disabled = true
	$Particles2D.emitting = true
	$Timer.wait_time = $Particles2D.lifetime
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
