class_name WalkComponent extends MovementComponent
## Drives horizontal ground/air movement toward [member direction].
##
## A controller sets [member direction] (-1..1) each frame; this applies it to
## velocity.x using [member stats] (with acceleration when advanced_movement is on).

@export var stats: MoveStats

## Movement intent for this frame, set by the controller. -1 left, 1 right, 0 stop.
var direction: float = 0.0

func apply(body: CharacterBody2D, delta: float) -> void:
	var on_floor := body.is_on_floor()
	var speed := stats.ground_speed if on_floor else stats.air_speed
	if not stats.advanced_movement:
		body.velocity.x = direction * speed
		return
	if direction != 0.0:
		var accel := stats.ground_acceleration if on_floor else stats.air_acceleration
		body.velocity.x = move_toward(body.velocity.x, direction * speed, accel * delta)
	else:
		var decel := stats.ground_deceleration if on_floor else stats.air_deceleration
		body.velocity.x = move_toward(body.velocity.x, 0.0, decel * delta)
