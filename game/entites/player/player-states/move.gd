class_name PlayerMove extends PlayerState
## MOVE STATE
##
## Ground left/right movement. Leaving the ground falls; stopping on the ground
## returns to idle; jump/dash input transitions accordingly.

@export_category("States")
@export var jump_state: FSMState
@export var fall_state: FSMState
@export var idle_state: FSMState
@export var dash_state: FSMState

## Entered only from the ground, so reset the jump counter.
func enter() -> void:
	super()
	if player.is_on_floor():
		move_stats.jumps_used = 0

func process_input(_event: InputEvent) -> FSMState:
	if player.is_on_floor():
		if get_jump_input():
			return jump_state
		if check_dash_conditions():
			return dash_state
	return null

func process_physics(delta: float) -> FSMState:
	move_stats.handle_horizontal_input(player, input.input_horizontal, delta)
	move_stats.handle_gravity(player, get_fastfall_input(), delta)
	player.move_and_slide()
	if not player.is_on_floor() and player.velocity.y > 0:
		return fall_state
	if player.is_on_floor() and not get_movement_input() and player.velocity.x == 0:
		return idle_state
	return null
