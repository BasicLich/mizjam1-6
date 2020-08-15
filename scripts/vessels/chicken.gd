extends KinematicBody2D


# Declare member variables here. Examples:
var possessed = false
var dizzy = 0

var move = Vector2()
var speed = 40

var abilityDelay = 1
var abilityTimer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$dizzy.visible = dizzy > 0
	
	if possessed:
		$CollisionShape2D/Sprite.flip_h = not get_global_mouse_position().x > get_global_position().x
		$AnimationPlayer.play("idle")
		
		abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
		
		#MOVE
		move = Vector2(0,0)
		if Input.is_action_pressed("mouseL"):
			if get_global_mouse_position().distance_to(get_global_position()) > 20:
				move = (get_global_mouse_position() - get_global_position()).normalized() * speed
		
		#SAY 'CHICK'
		if abilityTimer <= 0:
			if Input.is_action_just_pressed("mouseR"):
				print("'chick!'")
				abilityTimer = abilityDelay
	
	else:
		#DIZZY
		if dizzy > 0:
			$AnimationPlayer.play("dizzy")
			move = Vector2(0,0)
			dizzy -= delta
		else:
			$AnimationPlayer.play("idle")
			move = move*0.99
	
	
	move_and_slide(move)
	pass

func _on_Timer_timeout():
	#NPC MOVEMENT
	if not possessed:
		move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed
		$Timer.wait_time = randf()*3
	pass # Replace with function body.
