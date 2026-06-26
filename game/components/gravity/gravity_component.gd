class_name GravityComponent extends Node
## Applies gravity to a [CharacterBody2D] supplied by the owner.
##
## Add as a child of a body and call [method physics_update] from the owner's
## [method Node._physics_process], passing the body in. The component owns the
## gravity values but holds no reference to the body.
## TODO: low-gravity / air-gravity variants via [member low_gravity].

@export_subgroup("Settings")
## Downward force added to the body's velocity.y each step. Positive.
@export var gravity: float = 1000.0
## Stronger downward force used while fast-falling.
@export var fast_fall_gravity: float = 2000.0
## Reserved for a future low-gravity mode.
@export var low_gravity: float = 500.0

var paused: bool = false
var is_fast_falling: bool

## Applies gravity to [param body] unless paused or grounded. When [param fast_fall]
## is true the stronger [member fast_fall_gravity] is used.
func physics_update(body: CharacterBody2D, delta: float, fast_fall: bool = false) -> void:
	if paused or body.is_on_floor():
		return
	if fast_fall:
		body.velocity.y += fast_fall_gravity * delta
		is_fast_falling = true
	else:
		body.velocity.y += gravity * delta
		is_fast_falling = false
