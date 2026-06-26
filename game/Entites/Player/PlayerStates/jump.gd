class_name PlayerJump extends State
## JUMP STATE
##
## The jump state can only enter 2 states itself for multi jumping and falling


@export_category("Transitions")
@export var fall_state: State
@export var jump_state: State
@export var dash_state: State

func enter() -> void:
	super.enter()
	#Debug.debug(self, "Player Entered the Jump State\nJumps Used: %d" % move_stats.jumps_used, false)
	# Immediatly make the player jump.
	move_stats.handle_jump(parent)
	AudioController.play_sound("PlayerJump")
	parent.move_and_slide()

	
func process_input(_event: InputEvent) -> State:
	# IF MULTI JUMP IS ALLOWED
	if move_stats.multi_jump:
		if move_stats.max_jumps > move_stats.jumps_used:
			if get_jump_input():
				return jump_state
	
	# Allow dashes while jumping
	if check_dash_conditions():
		return dash_state
	return

func process_physics(delta: float) -> State:
	# HANDLE MOVING THE PLAYER AROUND
	move_stats.handle_gravity(parent, get_fastfall_input(), delta)
	move_stats.handle_horizontal_input(parent, input.input_horizontal, delta)
	parent.move_and_slide()

	# CHECK FOR STATE CHANGES
	if parent.velocity.y > 0:
		return fall_state
	return null
