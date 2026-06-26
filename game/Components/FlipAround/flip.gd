class_name FlipAround extends Node
@export var body : CharacterBody2D # the body to flip around

func init(b : CharacterBody2D):
	self.body = b
	assert(body != null, "body to flip around is null")

func update(delta : float):
	pass

func physics_update(delta : float):
	pass

# takes in the direction and deterimines if the position should flip
func direction_update(dir : int):
	pass
