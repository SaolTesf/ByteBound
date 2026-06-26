class_name PlayerIdle extends PlayerState
## IDLE STATE
##
## The player is doing nothing. Any input that makes the player act transitions
## out: jump/move/dash while on the floor, or fall when leaving the ground.

@export_category("States")
@export var move_state: FSMState
@export var jump_state: FSMState
@export var fall_state: FSMState
@export var dash_state: FSMState

## Coming to a stop resets the jump counter while grounded.
func enter() -> void:
	super()
	if player.is_on_floor():
		move_stats.jumps_used = 0
	player.velocity = Vector2.ZERO

func process_input(_event: InputEvent) -> FSMState:
	if player.is_on_floor() and move_stats.max_jumps > move_stats.jumps_used:
		if get_jump_input():
			return jump_state
		if get_movement_input():
			if check_dash_conditions():
				return dash_state
			return move_state
	return null

func process_physics(_delta: float) -> FSMState:
	if not player.is_on_floor():
		return fall_state
	return null
