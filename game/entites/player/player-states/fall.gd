class_name PlayerFall extends PlayerState
## FALL STATE
##
## The player is airborne and descending. Supports coyote-time and jump-buffer
## corrections, multi-jump, and dash before landing into idle/move/jump.

@export_category("Transitions")
@export_subgroup("States")
@export var move_state: FSMState
@export var idle_state: FSMState
@export var jump_state: FSMState
@export var dash_state: FSMState

var jump_buffer_time: float
var coyote_time: float
var _jump_buffer_timer: float
var _coyote_timer: float

func enter() -> void:
	super()
	set_up_player_corrections()

func process_frame(delta: float) -> FSMState:
	_jump_buffer_timer -= delta
	_coyote_timer -= delta
	return null

func process_input(_event: InputEvent) -> FSMState:
	if move_stats.multi_jump and not player.is_on_floor() and not player.is_on_wall():
		if move_stats.max_jumps > move_stats.jumps_used:
			if get_jump_input():
				return jump_state
	if check_dash_conditions():
		return dash_state
	if get_jump_input() and _coyote_timer > 0:
		return jump_state
	if get_jump_input():
		_jump_buffer_timer = jump_buffer_time
	return null

func process_physics(delta: float) -> FSMState:
	move_stats.handle_gravity(player, get_fastfall_input(), delta)
	move_stats.handle_horizontal_input(player, input.input_horizontal, delta)
	player.move_and_slide()
	if player.is_on_floor():
		if not get_movement_input() and _jump_buffer_timer < 0:
			return idle_state
		if get_movement_input() and _jump_buffer_timer < 0:
			return move_state
		if _jump_buffer_timer > 0:
			return jump_state
	return null

func set_up_player_corrections() -> void:
	coyote_time = move_stats.coyote_jump_time
	jump_buffer_time = move_stats.jump_buffer_time
	_jump_buffer_timer = 0
	_coyote_timer = 0
