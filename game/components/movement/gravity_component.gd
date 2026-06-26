class_name GravityComponent extends MovementComponent
## Applies downward gravity to a body's velocity.y while airborne.
##
## Owns its gravity values (independent of [MoveStats]) so any falling body can
## use it. A controller sets [member fast_fall] for an accelerated descent.

@export var gravity: float = 980.0
@export var fast_fall_gravity: float = 1500.0

## Set by the controller each frame; uses the stronger force when true.
var fast_fall: bool = false

func apply(body: CharacterBody2D, delta: float) -> void:
	if body.is_on_floor():
		return
	body.velocity.y += (fast_fall_gravity if fast_fall else gravity) * delta

## Legacy entry point for bodies not yet on a [LocomotionComponent] (key/box).
## Sets [member fast_fall] and applies once. Remove once those use locomotion.
func physics_update(body: CharacterBody2D, delta: float, fast_fall_now: bool = false) -> void:
	fast_fall = fast_fall_now
	apply(body, delta)
