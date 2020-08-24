extends Area2D


# Declare member variables here. Examples:
export var wanted = {}
var sacrificed = {}

export var destination: String = "menu" 

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in wanted:
		sacrificed[key] = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("vessel") and body.is_in_group("alive"):
			if body.state == Game.DIZZY:
				var killed = false
				for request in wanted:
					if not killed:
						if body.is_in_group(request):
							if sacrificed[request] < wanted[request]:
								body.die()
								killed = true
	
	var list = ""
	for item in wanted:
		if wanted[item] > sacrificed[item]:
			list = list + item + ": " + str(wanted[item]-sacrificed[item]) + "\n"
	$hint/List.text = list
	$hint.visible = not wanted.hash() == sacrificed.hash()
	
	if wanted.hash() == sacrificed.hash():
		$Area2D.visible = true
		if $Area2D.overlaps_body(Game.get_player()) and not Game.get_player().possessing:
			get_tree().change_scene("res://scenes/levels/" + destination + ".tscn")
	pass

func sacrifice(body):
	if body.is_in_group("vessel") and get_overlapping_bodies().has(body):
		var valid = false
		for request in wanted:
			if not valid:
				if body.is_in_group(request):
					if not sacrificed.has(request) or (sacrificed.has(request) and sacrificed[request] < wanted[request]):
						valid = true
						sacrificed[request] += 1
	body.queue_free()
