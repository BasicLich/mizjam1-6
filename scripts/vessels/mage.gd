extends KinematicBody2D


# Declare member variables here. Examples:
var possessed = false

var move = Vector2()
var speed = 100

const abilityDelay = 1
var abilityTimer = 0

const dizzyDelay = 5
var dizzyTimer = 0

var state = Game.IDLE

var path = PoolVector2Array()

const scaredDelay = 4
var scaredTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("mage")
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$dizzy.visible = state == Game.DIZZY
	$curious.visible = state == Game.CURIOUS
	$scared.visible = state == Game.SCARED
	$angry.visible = state == Game.ANGRY
	
	if global_position.distance_to(Game.get_player().global_position) <= 320 and (state == Game.IDLE or state == Game.CURIOUS):
		state = Game.ANGRY
		path = Game.get_main().get_node("Navigation2D").get_simple_path(global_position, Game.get_player().global_position, false)
	
	match state:
		Game.POSSESSED:
			possessed(delta)
		Game.DIZZY:
			dizzy(delta)
		Game.IDLE:
			idle()
		Game.CURIOUS:
			curious()
		Game.ANGRY:
			angry()
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
	
	
	#MOVE
	move = Vector2(0,0)
	if Input.is_action_pressed("mouseL"):
		if get_global_mouse_position().distance_to(get_global_position()) > 20:
			move = (get_global_mouse_position() - get_global_position()).normalized() * speed
	move_and_slide(move)
	
	#SAY 'Hey!'
	abilityTimer = clamp(abilityTimer - delta, 0, abilityDelay)
	if abilityTimer <= 0:
		if Input.is_action_just_pressed("mouseR"):
			cast_fireball(Game.get_player().get_node("arrow/Sprite").global_position)
			abilityTimer = abilityDelay
	
	pass

func curious():
	move_and_slide((path[0]-global_position).normalized()*speed)
	if path[0].distance_to(global_position) <= 32:
		path.remove(0)
	pass

func angry():
	if global_position.distance_to(Game.get_player().global_position) > 320:
		move_and_slide((path[0]-global_position).normalized()*speed)
		if path[0].distance_to(global_position) <= 32:
			path.remove(0)

func scared(delta):
	$CollisionShape2D/Sprite.flip_h = move.x < 0
	
	scaredTimer = clamp(scaredTimer - delta, 0, scaredDelay)
	if scaredTimer == 0:
		state = Game.ANGRY
	
	move = move*0.99
	move_and_slide(move)
	

func _on_Timer_timeout():
	#NPC MOVEMENT
	if state != Game.POSSESSED:
		if state == Game.ANGRY:
			path = Game.get_main().get_node("Navigation2D").get_simple_path(global_position, Game.get_player().global_position, false)
			$Timer.wait_time = 1 + randf()/2
			cast_fireball(Game.get_player().global_position)
		elif state == Game.SCARED:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed*4
			$Timer.wait_time = randf()/2
		else:
			move = Vector2(((randf()-0.5)*2), ((randf()-0.5)*2)).normalized()*speed
			$Timer.wait_time = randf()*1
	pass # Replace with function body.

func get_curious(where):
	if state == Game.IDLE or state == Game.CURIOUS:
		state = Game.CURIOUS
		path = Game.get_main().get_node("Navigation2D").get_simple_path(global_position, where, false)

func be_scared():
	if state == Game.IDLE:
		scaredTimer = scaredDelay
		state = Game.SCARED
		$Timer.start(0.1)

func cast_fireball(target):
	var fireball = load("res://scenes/others/fireball.tscn").instance()
	fireball.global_position = global_position
	fireball.look_at(target)
	fireball.dadName = name
	Game.get_main().add_child(fireball)
	pass
