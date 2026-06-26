class_name DashComponent extends MovementComponent
## A timed horizontal dash with a cooldown.
##
## The controller calls [method dash]; while dashing this overrides horizontal
## velocity and cancels vertical velocity. Runs after walk/gravity in the
## locomotion order so it takes precedence while active.

@export var stats: MoveStats

var is_dashing: bool = false
var _direction: float = 0.0
var _time_left: float = 0.0
var _cooldown_left: float = 0.0

func apply(body: CharacterBody2D, delta: float) -> void:
	if _cooldown_left > 0.0:
		_cooldown_left -= delta
	if not is_dashing:
		return
	_time_left -= delta
	body.velocity.x = _direction * stats.ground_speed * stats.dash_multiplier
	body.velocity.y = 0.0
	if _time_left <= 0.0:
		is_dashing = false
		_cooldown_left = stats.dash_cooldown

## True if a dash can start right now.
func can_dash() -> bool:
	return stats.enable_dash and not is_dashing and _cooldown_left <= 0.0

## Starts a dash in [param direction] if available.
func dash(direction: float) -> void:
	if not can_dash():
		return
	is_dashing = true
	_direction = direction
	_time_left = stats.dash_duration
