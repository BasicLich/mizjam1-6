extends KinematicBody2D


# Declare member variables here. Examples:

var move = Vector2()
var dash = Vector2()
var speed = 50
var dashSpeed = 300

const abilityDelay = 1
var abilityTimer = 0

const scaredDelay = 4
var scaredTimer = 0

var state = Game.IDLE

var color = Game.rand_color()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("alive")
	add_to_group("bear")
	randomize()
	$Timer.start(0)
	pass # Replace with function body.



func _physics_process(delta):
	$dizzy.visible = state == Game.DIZZY
	$scared.visible = scaredTimer > 0
	$CollisionShape2D/Sprite.flip_h = move.x < 0	
	
	match state:
		Game.POSSESSED:
			possessed(delta)
		Game.DIZZY:
			dizzy()
		Game.IDLE:
			idle()
		Game.SCARED:
			scared(delta)
	pass

func idle():
	$AnimationPlayer.play("idle")
	
	move = move*0.99
	move_and_slide(move)
	pass

func dizzy():
	$AnimationPlayer.play("dizzy")
	move = Vector2(0,0)
	pass


func possessed(delta):
	$CollisionShape2D/Sprite.flip_h = not get_global_mouse_position().x > get_global_position().x
	$AnimationPlayer.play("idle")
	scaredTimer = 0
	
	#MOVE
	move = Vector2(0,0)
	if Input.is_action_pressed("mouseR"):
		if get_global_mouse_position().distance_to(get_global_position()) > 20:
			move = (get_global_mouse_position() - get_global_position()).normalized() * speed
	
	#HIT
	abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
	if abilityTimer <= 0:
		if Input.is_action_just_pressed("mouseL"):
			dash = (get_global_mouse_position() - get_global_position()).normalized() * dashSpeed
			abilityTimer = abilityDelay
	
			#DASH
		if abilityTimer <= 0:
			if Input.is_action_just_pressed("mouseL"):
				dash = (get_global_mouse_position() - get_global_position()).normalized() * dashSpeed
				abilityTimer = abilityDelay
				$Dash.play()
		
	move_and_slide(move + dash)
	if dash.length() > 100:
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("wood"):
				body.remove()
				dash = dash*0.5
			elif body.is_in_group("alive") and body != self:
				body.die()
				dash = dash*0.5
		
	if dash.length() > speed:
		dash = dash*0.9
		move = move*0.7
	else:
		dash = Vector2(0,0)
		move = move*0.9
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
			$AudioStreamPlayer2D.play()
		else:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed
			$Timer.wait_time = randf()*3
	pass

func die():
	var headstone = load("res://scenes/others/headstone.tscn").instance()
	headstone.name = "headstone" + name
	headstone.global_position = global_position
	Game.get_main().add_child(headstone)
	if state != Game.DIZZY:
		var soul = load("res://scenes/soul.tscn").instance()
		soul.human = is_in_group("human")
		soul.body = headstone
		soul.bodyName = headstone.name
		soul.color = color
		soul.global_position = global_position
		Game.get_main().add_child(soul)
	Game.get_sacrifice().sacrifice(self)

func leave_soul():
	var soul = load("res://scenes/soul.tscn").instance()
	soul.human = is_in_group("human")
	soul.body = self
	soul.bodyName = name
	soul.color = color
	soul.global_position = global_position
	Game.get_main().add_child(soul)
	pass
