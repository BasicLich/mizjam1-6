extends KinematicBody2D


# Declare member variables here. Examples:
var possessed = false

var move = Vector2()
var speed = 100

const abilityDelay = 1
var abilityTimer = 0

var state = Game.IDLE

var path = PoolVector2Array()

const scaredDelay = 4
var scaredTimer = 0

var life = 5

var color = Game.rand_color()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vessel")
	add_to_group("alive")
	add_to_group("human")
	add_to_group("priest")
	randomize()
	pass # Replace with function body.



func _physics_process(delta):
	$dizzy.visible = state == Game.DIZZY
	$curious.visible = state == Game.CURIOUS
	$scared.visible = state == Game.SCARED
	$angry.visible = state == Game.ANGRY
	
	if state != Game.ANGRY:
		for body in $Area2D.get_overlapping_bodies():
			if body == Game.get_player():
				if not Game.get_player().possessing or (Game.get_player().possessing and Game.get_player().possessing.is_in_group("weapon")) or (Game.get_player().possessing and state == Game.CURIOUS):
					$RayCast.cast_to = Game.get_player().global_position - global_position
					$RayCast.force_raycast_update()
					if $RayCast.get_collider() == Game.get_player():
						state = Game.ANGRY
	
	match state:
		Game.POSSESSED:
			possessed(delta)
		Game.DIZZY:
			dizzy()
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

func dizzy():
	$AnimationPlayer.play("dizzy")
	move = Vector2(0,0)
	pass

func possessed(delta):
	Game.get_player().depossess
	
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
	if len(path) < 2:
		state = Game.IDLE
	if path[0].distance_to(global_position) <= 32:
		path.remove(0)
	pass

func angry():
	$RayCast.cast_to = Game.get_player().global_position - global_position
	$RayCast.force_raycast_update()
	if $RayCast.get_collider() != Game.get_player():
		get_curious(Game.get_player().global_position)
	
	if len(path) > 2 and global_position.distance_to(Game.get_player().global_position) > 32:
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
	if state == Game.IDLE or state == Game.CURIOUS or state == Game.ANGRY:
		state = Game.CURIOUS
		path = Game.get_main().get_node("Navigation2D").get_simple_path(global_position, where, false)

func be_scared():
	state = Game.ANGRY
	if state == Game.IDLE:
		scaredTimer = scaredDelay
		state = Game.SCARED
		$Timer.start(0.1)

func cast_fireball(target):
	$fire.play()
	var fireball = load("res://scenes/others/fireball.tscn").instance()
	fireball.global_position = global_position
	fireball.look_at(target)
	fireball.dadName = name
	Game.get_main().add_child(fireball)
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
