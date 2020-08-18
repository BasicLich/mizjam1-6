extends KinematicBody2D


# Declare member variables here. Examples:
var move = Vector2()
var dash = Vector2()
var speed = 10#25
var dashSpeed = 500#750

const dashDelay = 1.5
var dashTimer = 0

var possessing = null
var scaring = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	$CollisionShape2D.visible = not possessing
	$Arrow.look_at(get_global_mouse_position())
	
	#WHEN NOT POSSESSING
	if not possessing:
		$CollisionShape2D/Ghost.flip_h = get_global_mouse_position().x > get_global_position().x
		
		#DASH ABILITY TIMER
		if dashTimer <= 0:
			$Arrow/Arrow.texture = load("res://sprites/arrow_full.png")
			$Arrow/Arrow.modulate = Color(0,1,0)
		else:
			$Arrow/Arrow.texture = load("res://sprites/arrow.png")
			$Arrow/Arrow.modulate = Color(1,0,0)
			dashTimer = clamp(dashTimer - delta, 0, dashDelay)
		
		#MOVEMENT
		if Input.is_action_pressed("mouseL"):
			if get_global_mouse_position().distance_to(get_global_position()) > 20:
				move += (get_global_mouse_position() - get_global_position()).normalized() * speed
		
		#DASH
		if dashTimer <= 0 and not scaring:
			if Input.is_action_just_pressed("mouseR"):
				dash = (get_global_mouse_position() - get_global_position()).normalized() * dashSpeed
				dashTimer = dashDelay
				for body in $PossessionArea.get_overlapping_bodies():
					if not possessing:
						possess(body)
				#dash = (get_global_mouse_position() - get_global_position()).normalized() * get_global_mouse_position().distance_to(get_global_position()) * dashSpeed
		
		#SCARE
		if Input.is_action_just_pressed("space"):
			$AnimationPlayer.play("scare")
			$ScaringTimer.start()
			scaring = true
		if scaring:
			for body in $ScaringArea.get_overlapping_bodies():
					if body.is_in_group("vessel"):
						$RayCast.cast_to = body.global_position - global_position
						$RayCast.force_raycast_update()
						if $RayCast.get_collider() == body:
							body.be_scared()
		
		
		#GOING THROUGH WALLS
		set_collision_layer_bit(2, dash.length() <= 100 and not possessing)
		set_collision_mask_bit(2, dash.length() <= 100 and not possessing)
		
		
		move_and_slide(move + dash)
		
		if dash.length() > 100:
			$CollisionShape2D/Ghost.modulate = Color(1, 0.5, 0.5)
			dash = dash*0.9
			move = move*0.7
		else:
			dash = Vector2(0,0)
			$CollisionShape2D/Ghost.modulate = Color(1, 1, 1)
			move = move*0.9
	
	
	#WHEN POSSESSING
	else:
		global_position = possessing.global_position
		
		
		if possessing.abilityTimer <= 0:
			$Arrow/Arrow.texture = load("res://sprites/arrow_full.png")
			$Arrow/Arrow.modulate = Color(0,1,0)
		else:
			$Arrow/Arrow.texture = load("res://sprites/arrow.png")
			$Arrow/Arrow.modulate = Color(1,0,0)
		
		#STOP POSSESSING
		if Input.is_action_just_pressed("space"):
			possessing.state = Game.DIZZY
			possessing.dizzyTimer = possessing.dizzyDelay
			possessing.get_node("CollisionShape2D/Sprite").modulate = Color(1,1,1)
			possessing = null
	pass


func _on_Area2D_body_entered(body):
	if dash.length() > 100:
		possess(body)
	pass # Replace with function body.



#POSSESS VESSEL
func possess(vessel):
	if not possessing:
		if vessel.is_in_group("vessel"):
			if vessel.state == Game.SCARED:
				possessing = vessel
				vessel.state = Game.POSSESSED
				move = Vector2(0,0)
				dash = Vector2(0,0)
				vessel.get_node("CollisionShape2D/Sprite").modulate = Color(1,0,1)


func _on_Timer_timeout():
	$AnimationPlayer.play("idle")
	scaring = false
	pass # Replace with function body.
