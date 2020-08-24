extends KinematicBody2D


# Declare member variables here. Examples:
var body
var bodyName
var human = false

var speed = 100
var move = Vector2(0,0)

var color

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/Sprite.modulate = color
	if Game.get_main().has_node(bodyName):
		human = body.is_in_group("human")
		speed = body.speed
	else:
		$CollisionShape2D/Sprite.modulate = Game.rand_color()
	if human:
		$CollisionShape2D/Sprite.texture = load("res://sprites/soul.png")
	else:
		$CollisionShape2D/Sprite.texture = load("res://sprites/soul_animal.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$CollisionShape2D/Sprite.flip_h = move.x >= 0
	if Game.get_main().has_node(bodyName):
		$CollisionShape2D/Sprite/Line2D.points = PoolVector2Array([Vector2(0,0), body.global_position - global_position])
		$CollisionShape2D/Sprite/Line2D.visible = not body.is_in_group("headstone")
		if body.is_in_group("headstone"):
			move = (body.global_position+Vector2(0,-32) - global_position).normalized() * 100
			if global_position.distance_to(body.global_position+Vector2(0,-32)) > 2:
				move_and_slide(move)
		else:
			if body.state == Game.POSSESSED:
				move = (body.global_position - global_position).normalized() * 100 * 0.25#speed * 0.25
			else:
				move = (body.global_position - global_position).normalized() * 100 * 0.5#speed * 0.5
			move_and_slide(move)
		
		if $Area2D.overlaps_body(body):
			if body.state == Game.DIZZY:
				body.state = Game.IDLE
				queue_free()
		
	else:
		if Game.get_main().has_node('headstone' + bodyName):
			body = Game.get_main().get_node('headstone' + bodyName)
			bodyName = 'headstone' + bodyName
	pass
