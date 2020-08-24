extends KinematicBody2D


# Declare member variables here. Examples:
var state = Game.SCARED

var move = Vector2()
var speed = 15

const abilityDelay = 0.75
var abilityTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("weapon")
	pass # Replace with function body.


func _physics_process(delta):
	if state == Game.POSSESSED:
		abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
		
		#MOVEMENT
		if Input.is_action_pressed("mouseR"):
			if get_global_mouse_position().distance_to(get_global_position()) > 20:
				move += (get_global_mouse_position() - get_global_position()).normalized() * speed
		
		if Input.is_action_pressed("mouseL") and abilityTimer == 0:
			abilityTimer = abilityDelay
			explode()
		
		move_and_slide(move)
		move = move*0.9
	pass

func explode():
	$CollisionShape2D.visible = false
	$CollisionShape2D.disabled = true
	for body in $Area2D.get_overlapping_bodies():
		$RayCast.cast_to = body.global_position - global_position
		$RayCast.force_raycast_update()
		if $RayCast.get_collider() == null:
			if body.is_in_group("fence"):
				body.remove()
			elif body.is_in_group("alive"):
				body.die()
	Game.get_player().depossess()
	$Particles2D.emitting = true
	$Timer.start()
	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
