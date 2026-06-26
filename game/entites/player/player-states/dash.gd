class_name PlayerDash extends PlayerState
## DASH STATE — triggers a timed dash, then returns to move/idle/fall when it ends.

@export_category("States")
@export var move_state: FSMState
@export var idle_state: FSMState
@export var fall_state: FSMState

var _direction: float

func enter() -> void:
	super()
	_direction = _facing()
	dash.dash(_direction)

func process_physics(_delta: float) -> FSMState:
	if dash.is_dashing:
		return null
	if not player.is_on_floor() and player.velocity.y > 0:
		return fall_state
	if get_movement_input():
		return move_state
	return idle_state

func _facing() -> float:
	if get_left_input():
		return -1.0
	if get_right_input():
		return 1.0
	return float(player.dir)
