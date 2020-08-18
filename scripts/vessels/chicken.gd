extends KinematicBody2D


# Declare member variables here. Examples:

var move = Vector2()
var speed = 40

const abilityDelay = 1
var abilityTimer = 0

const dizzyDelay = 1
var dizzyTimer = 0

const scaredDelay = 4
var scaredTimer = 0

var state = Game.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("chicken")
	randomize()
	$Timer.start(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$dizzy.visible = state == Game.DIZZY
	$scared.visible = scaredTimer > 0 or (state == Game.POSSESSED and abilityTimer > 0)
	
	match state:
		Game.POSSESSED:
			possessed(delta)
		Game.DIZZY:
			dizzy(delta)
		Game.IDLE:
			idle()
		Game.SCARED:
			scared(delta)
	pass

func idle():
	$AnimationPlayer.play("idle")
	$CollisionShape2D/Sprite.flip_h = move.x < 0
	
	move = move*0.99
	move_and_slide(move)
	pass

func dizzy(delta):
	$AnimationPlayer.play("dizzy")
	move = Vector2(0,0)
	dizzyTimer = clamp(dizzyTimer - delta, 0, dizzyDelay)
	if dizzyTimer <= 0:
		state = Game.IDLE
	pass


func possessed(delta):
	$CollisionShape2D/Sprite.flip_h = not get_global_mouse_position().x > get_global_position().x
	$AnimationPlayer.play("idle")
	scaredTimer = 0
	
	#MOVE
	move = Vector2(0,0)
	if Input.is_action_pressed("mouseL"):
		if get_global_mouse_position().distance_to(get_global_position()) > 20:
			move = (get_global_mouse_position() - get_global_position()).normalized() * speed
	move_and_slide(move)
	
	
	#SAY 'CHICK'
	abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
	if abilityTimer <= 0:
		if Input.is_action_just_pressed("mouseR"):
			$AudioStreamPlayer2D.play()
			abilityTimer = abilityDelay
			call_farmer()
	pass

func scared(delta):
	$CollisionShape2D/Sprite.flip_h = move.x < 0
	
	scaredTimer = clamp(scaredTimer - delta, 0, scaredDelay)
	if scaredTimer == 0:
		state = Game.IDLE
	
	move = move*0.99
	move_and_slide(move)
	pass

func be_scared():
	if state == Game.IDLE or state == Game.SCARED:
		scaredTimer = scaredDelay
		state = Game.SCARED
#		move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed*4
		$Timer.stop()
		$Timer.wait_time = randf()/2
		$Timer.start()
	pass

func _on_Timer_timeout():
	#NPC MOVEMENT
	if state != Game.POSSESSED:
		if state == Game.SCARED:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed*4
			$Timer.wait_time = randf()/2
			call_farmer()
		else:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed
			$Timer.wait_time = randf()*3
		$AudioStreamPlayer2D.play()
	pass # Replace with function body.

func call_farmer():
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("farmer"):
			body.get_curious(global_position)
