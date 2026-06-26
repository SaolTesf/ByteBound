extends Node2D

@export var body : CharacterBody2D
@export var offset : Vector2 = Vector2(0,0)
@export var on_right_side : bool

func init(body: CharacterBody2D):
	self.body = body

func update_direction(input : InputComponent):
	if input.get_left(): on_right_side = false
	if input.get_right() : on_right_side = true
	
	if on_right_side:
		position.x = abs(position.x)
	else:
		position.x = -abs(position.x)

