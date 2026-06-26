class_name JumpComponent extends MovementComponent
## Vertical jump impulses, including multi-jump.
##
## The controller calls [method jump]; the air-jump counter resets automatically
## on landing. [member stats] supplies jump height and max jumps.

@export var stats: MoveStats

var jumps_used: int = 0

func apply(body: CharacterBody2D, _delta: float) -> void:
	# Reset once landed (but not on the frame we leave the ground rising).
	if body.is_on_floor() and body.velocity.y >= 0.0:
		jumps_used = 0

## True if another jump is allowed right now.
func can_jump() -> bool:
	return jumps_used < stats.max_jumps

## Applies a jump impulse to [param body] (scaled for air jumps).
func jump(body: CharacterBody2D) -> void:
	if jumps_used == 0:
		body.velocity.y = stats.jump_height
	else:
		body.velocity.y = stats.jump_height * stats.multi_jump_height_multiplier
	jumps_used += 1
