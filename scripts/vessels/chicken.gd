extends KinematicBody2D


# Declare member variables here. Examples:

var move = Vector2()
var speed = 40

const abilityDelay = 1
var abilityTimer = 0

const scaredDelay = 4
var scaredTimer = 0

var state = Game.IDLE

var path = PoolVector2Array()
var following = ''

var color = Game.rand_color()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("alive")
	add_to_group("chicken")
	randomize()
	$Timer.start(0)
	pass # Replace with function body.



func _physics_process(delta):
	$dizzy.visible = state == Game.DIZZY
	$curious.visible = state == Game.CURIOUS
	$scared.visible = scaredTimer > 0 or (state == Game.POSSESSED and abilityTimer > 0)
	$CollisionShape2D/Sprite.flip_h = move.x < 0	
	
	if state != Game.CURIOUS:
		following = null
	
	match state:
		Game.POSSESSED:
			possessed(delta)
		Game.DIZZY:
			dizzy()
		Game.IDLE:
			idle()
		Game.SCARED:
			scared(delta)
		Game.CURIOUS:
			curious()
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
			move = (get_global_mouse_position() - get_global_position()).normalized() * speed * 2
	move_and_slide(move)
	
	
	#SAY 'CHICK'
	abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
	if abilityTimer <= 0:
		if Input.is_action_just_pressed("mouseL"):
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

func curious():
	if not Game.get_main().has_node(following):
		state = Game.IDLE
		following = ''
	elif len(path) > 1:
		move_and_slide((path[0]-global_position).normalized()*speed)
		if path[0].distance_to(global_position) <= 32:
			path.remove(0)
	pass

func be_scared():
	if state == Game.IDLE or state == Game.SCARED or state == Game.CURIOUS:
		scaredTimer = scaredDelay
		following = ''
		state = Game.SCARED
		$Timer.stop()
		$Timer.wait_time = randf()/2
		$Timer.start()
	pass

func get_curious(who):
	if state == Game.IDLE or state == Game.CURIOUS:
		state = Game.CURIOUS
		path = Game.get_main().get_node("Navigation2D").get_simple_path(global_position, Game.get_main().get_node(who).global_position, false)
		following = who

func _on_Timer_timeout():
	#NPC MOVEMENT
	if state != Game.POSSESSED:
		if state == Game.SCARED:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed*4
			$Timer.wait_time = randf()/2
			call_farmer()
		elif state == Game.CURIOUS:
			if following != '':
				path = Game.get_main().get_node("Navigation2D").get_simple_path(global_position, Game.get_main().get_node(following).global_position, false)
			else:
				state = Game.IDLE
			$Timer.wait_time = 1
		else:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed
			$Timer.wait_time = randf()*3
		$AudioStreamPlayer2D.play()
	pass # Replace with function body.

func call_farmer():
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("farmer"):
			body.get_curious(global_position)

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
