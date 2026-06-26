class_name PlayerMove extends State
## MOVE STATE
##
## This State is all about how the player moves left to right on the ground.
## As such if the player leaves the ground the state needs to change.
## If the player is on the ground and velocity.x = 0 go back to idle 
## and if the player is on the ground and asks to jump go to jump state

@export_category("States")
@export var jump_state: State
@export var fall_state: State
@export var idle_state: State
@export var dash_state: State



func enter() -> void:
	
	super.enter()
#	Debug.debug(self, "Player Entered Move State", false)
	if parent.is_on_floor():
		move_stats.jumps_used = 0
	# player can only enter this state on the ground then we should reset the jumps
	
func exit() -> void:
	super.exit()
	
func process_input(_event: InputEvent) -> State:
	if parent.is_on_floor():
		if get_jump_input():
			return jump_state
		if check_dash_conditions():
			return dash_state
	return null

func process_physics(delta: float) -> State:
	# MOVE THE PLAYER HERE
	move_stats.handle_horizontal_input(parent, input.input_horizontal, delta)
	move_stats.handle_gravity(parent, get_fastfall_input(), delta)
	parent.move_and_slide()
	
	# DO STATE CHANGES HERE
	if !parent.is_on_floor() and parent.velocity.y > 0:
		return fall_state
	if parent.is_on_floor() and !get_movement_input() and parent.velocity.x == 0:
		return idle_state
	# If State does not change return null
	return null
