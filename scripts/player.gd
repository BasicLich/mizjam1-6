extends KinematicBody2D


# Declare member variables here. Examples:
var move = Vector2()
var dash = Vector2()
var speed = 25
var dashSpeed = 500

const dashDelay = 1.5
var dashTimer = 0

var possessing = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	$CollisionShape2D.visible = not possessing
	$Arrow.look_at(get_global_mouse_position())
	$Arrow/Arrow.visible = not possessing or not possessing.is_in_group("headstone")
	
	#WHEN NOT POSSESSING
	if not possessing:
		$CollisionShape2D/Ghost.flip_h = get_global_mouse_position().x > get_global_position().x
		$ScaringArea/Light2D.visible = $AnimationPlayer.current_animation == "scare"
		
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
		if dashTimer <= 0 and not $AnimationPlayer.current_animation == "scare":
			if Input.is_action_just_pressed("mouseR"):
				dash = (get_global_mouse_position() - get_global_position()).normalized() * dashSpeed
				dashTimer = dashDelay
				for body in $PossessionArea.get_overlapping_bodies():
					if not possessing:
						possess(body)
		
		#SCARE
		if Input.is_action_just_pressed("space"):
			$AnimationPlayer.play("scare")
			$ScaringTimer.start()
		if $AnimationPlayer.current_animation == "scare":
			dashTimer = dashDelay
			for body in $ScaringArea.get_overlapping_bodies():
				scare(body)
		
		
		#GOING THROUGH WALLS
		set_collision_layer_bit(2, dash.length() <= 100 and not possessing)
		set_collision_mask_bit(2, dash.length() <= 100 and not possessing)
		
		if not $AnimationPlayer.current_animation == "scare":
			move_and_slide(move + dash)
		
		if dash.length() > speed:
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
		
		if not possessing.is_in_group("headstone"):
			if possessing.abilityTimer <= 0:
				$Arrow/Arrow.texture = load("res://sprites/arrow_full.png")
				$Arrow/Arrow.modulate = Color(0,1,0)
			else:
				$Arrow/Arrow.texture = load("res://sprites/arrow.png")
				$Arrow/Arrow.modulate = Color(1,0,0)
		
		$ScaringArea/Light2D.visible = possessing.is_in_group("weapon")
		if possessing.is_in_group("weapon"):
			for body in $ScaringArea.get_overlapping_bodies():
				scare(body)
		
		#STOP POSSESSING
		if Input.is_action_just_pressed("space"):
			depossess()
	pass


func _on_Area2D_body_entered(body):
	if dash.length() > 100:
		possess(body)
	pass # Replace with function body.

func scare(body):
	if body.is_in_group("vessel") and body.is_in_group("alive"):
		$RayCast.cast_to = body.global_position - global_position
		$RayCast.force_raycast_update()
		if $RayCast.get_collider() == null:
			body.be_scared()
	pass

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
				if vessel.is_in_group("alive"):
					vessel.leave_soul()
				if not vessel.is_in_group("headstone"):
					vessel.abilityTimer = vessel.abilityDelay

#STOP POSSESSING VESSEL
func depossess():
	if possessing.is_in_group("alive"):
		possessing.state = Game.DIZZY
	else:
		possessing.state = Game.SCARED
	possessing.get_node("CollisionShape2D/Sprite").modulate = Color(1,1,1)
	possessing = null
	dashTimer = dashDelay
	pass

func _on_Timer_timeout():
	$AnimationPlayer.play("idle")
	pass # Replace with function body.
