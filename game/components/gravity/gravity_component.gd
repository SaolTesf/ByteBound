class_name GravityComponent extends Node
## This component applies gravity to a [PhysicsBody2D]
##
## This component should be added as a child node of any [PhysicsBody2D]
## The component modifies velocity.y and determine if the body is falling
## TODO: Can be extended to allow for different types of gravitys:
##		- Low gravity ()
##		- Air gravity (changes how floaty a character is)

@export_subgroup("Settings")
## The amount of force to be applied to the body.velocity.y 
## This value should be positive
@export var gravity: float = 1000.0
@export var fast_fall_gravity: float = 2000.0
@export var low_gravity: float = 500.0
var paused : bool = false

## Will be true if the body is not on the floor 
## and the body.velocity.y is positive
var is_falling: bool
var is_fast_falling: bool

var body : CharacterBody2D


func init(b : CharacterBody2D) -> void:
	body = b


## If the player is not on the floor apply a downward force.
## This is only applied if they are not on the floor 
## keeping the velocity.y from causing isues if the actor jumps
func physics_update(delta: float, fast_fall : bool = false) -> void:
	if !paused:
		if not body.is_on_floor():
			if fast_fall:
				body.velocity.y += fast_fall_gravity * delta
				is_fast_falling = true
			else:
				body.velocity.y += gravity * delta
				is_fast_falling = false

