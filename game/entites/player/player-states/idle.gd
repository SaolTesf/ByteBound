class_name PlayerIdle extends PlayerState
## IDLE STATE — the player stands still; any action transitions out.

@export_category("States")
@export var move_state: FSMState
@export var jump_state: FSMState
@export var fall_state: FSMState
@export var dash_state: FSMState

func enter() -> void:
	super()
	walk.direction = 0.0
	player.velocity.x = 0.0

func process_input(_event: InputEvent) -> FSMState:
	if player.is_on_floor() and jump.can_jump():
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
