class_name PlayerFall extends PlayerState
## FALL STATE — airborne and descending; supports coyote-time and jump-buffering.

@export_category("Transitions")
@export_subgroup("States")
@export var move_state: FSMState
@export var idle_state: FSMState
@export var jump_state: FSMState
@export var dash_state: FSMState

var _jump_buffer_timer: float
var _coyote_timer: float

func enter() -> void:
	super()
	_jump_buffer_timer = 0.0
	_coyote_timer = move_stats.coyote_jump_time

func process_frame(delta: float) -> FSMState:
	_jump_buffer_timer -= delta
	_coyote_timer -= delta
	return null

func process_input(_event: InputEvent) -> FSMState:
	if move_stats.multi_jump and jump.can_jump() and not player.is_on_floor() and not player.is_on_wall():
		if get_jump_input():
			return jump_state
	if check_dash_conditions():
		return dash_state
	if get_jump_input() and _coyote_timer > 0.0:
		return jump_state
	if get_jump_input():
		_jump_buffer_timer = move_stats.jump_buffer_time
	return null

func process_physics(_delta: float) -> FSMState:
	walk.direction = input.input_horizontal
	gravity.fast_fall = get_fastfall_input()
	if player.is_on_floor():
		if _jump_buffer_timer > 0.0:
			return jump_state
		if get_movement_input():
			return move_state
		return idle_state
	return null
