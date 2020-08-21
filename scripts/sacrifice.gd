extends Area2D


# Declare member variables here. Examples:
export var wanted = {}

var sacrificed = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in wanted:
		sacrificed[key] = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wanted.hash() == sacrificed.hash():
		print("WIN")
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
