extends KinematicBody2D


# Declare member variables here. Examples:
var state = Game.SCARED

var move = Vector2()
var dash = Vector2()
var speed = 15
var dashSpeed = 300

const abilityDelay = 0.75
var abilityTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("weapon")
	pass # Replace with function body.


func _physics_process(delta):
	if state == Game.POSSESSED:
		look_at(get_global_mouse_position())
		abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
		
		#MOVEMENT
		if Input.is_action_pressed("mouseR"):
			if get_global_mouse_position().distance_to(get_global_position()) > 20:
				move += (get_global_mouse_position() - get_global_position()).normalized() * speed
		
		#DASH
		if abilityTimer <= 0:
			if Input.is_action_just_pressed("mouseL"):
				dash = (get_global_mouse_position() - get_global_position()).normalized() * dashSpeed
				abilityTimer = abilityDelay
		
		move_and_slide(move + dash)
		if dash.length() > 100:
			for body in $Area2D.get_overlapping_bodies():
				if body.is_in_group("rock"):
					body.remove()
					dash = dash*0.5
		
		
		if dash.length() > speed:
			dash = dash*0.9
			move = move*0.7
		else:
			dash = Vector2(0,0)
			move = move*0.9
	pass
