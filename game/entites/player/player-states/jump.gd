class_name PlayerJump extends PlayerState
## JUMP STATE
##
## Applies the jump impulse on entry. Can multi-jump (if enabled) or dash, and
## transitions to fall once the player starts descending.

@export_category("Transitions")
@export var fall_state: FSMState
@export var jump_state: FSMState
@export var dash_state: FSMState

func enter() -> void:
	super()
	move_stats.handle_jump(player)
	AudioController.play_sound("PlayerJump")
	player.move_and_slide()

func process_input(_event: InputEvent) -> FSMState:
	if move_stats.multi_jump and move_stats.max_jumps > move_stats.jumps_used:
		if get_jump_input():
			return jump_state
	if check_dash_conditions():
		return dash_state
	return null

func process_physics(delta: float) -> FSMState:
	move_stats.handle_gravity(player, get_fastfall_input(), delta)
	move_stats.handle_horizontal_input(player, input.input_horizontal, delta)
	player.move_and_slide()
	if player.velocity.y > 0:
		return fall_state
	return null
