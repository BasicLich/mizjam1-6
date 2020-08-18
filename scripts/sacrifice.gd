extends Area2D


# Declare member variables here. Examples:
export var wanted = {"farmer": 1}

var sacrificed = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("vessel"):
			if body.state == Game.DIZZY:
				var killed = false
				for request in wanted:
					if not killed:
						if body.is_in_group(request):
							if not sacrificed.has(request) or (sacrificed.has(request) and sacrificed[request] < wanted[request]):
								killed = true
								var soul = load("res://scenes/soul.tscn").instance()
								soul.global_position = body.global_position
								Game.get_main().add_child(soul)
								body.queue_free()
								if sacrificed.has(request):
									sacrificed[request] += 1
								else:
									sacrificed[request] = 1
	
	if wanted.hash() == sacrificed.hash():
		print("WIN")
	pass
