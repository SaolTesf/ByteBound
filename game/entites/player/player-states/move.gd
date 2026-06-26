class_name PlayerMove extends PlayerState
## MOVE STATE — ground left/right movement; leaving the ground falls.

@export_category("States")
@export var jump_state: FSMState
@export var fall_state: FSMState
@export var idle_state: FSMState
@export var dash_state: FSMState

func process_input(_event: InputEvent) -> FSMState:
	if player.is_on_floor():
		if get_jump_input():
			return jump_state
		if check_dash_conditions():
			return dash_state
	return null

func process_physics(_delta: float) -> FSMState:
	walk.direction = input.input_horizontal
	gravity.fast_fall = get_fastfall_input()
	if not player.is_on_floor() and player.velocity.y > 0:
		return fall_state
	if player.is_on_floor() and not get_movement_input() and player.velocity.x == 0:
		return idle_state
	return null
