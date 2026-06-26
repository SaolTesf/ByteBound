class_name PlayerIdle extends State
## IDLE STATE
##
## In the Idle state the player is doing one thing nothing. [br]
## As such any change that causes the player to do something should cause the actor to change states [br]
## From the Idle State the following states should be accessable: [br]
## MoveState (on ground and input.axis(left, right))
## JumpState (on ground and input.ui_accept)
## FallState (!on ground)
## Since the player is not moving in the idle state no physics need to be processed

@export_category("States")
@export var move_state: State
@export var jump_state: State
@export var fall_state: State
@export var dash_state: State

## Upon entering the idle state all velocity the actor should come to a complete stop.
func enter() -> void:
	super()
	#Debug.debug(self, "Player Entered the idle State", false)
	if parent.is_on_floor():
		move_stats.jumps_used = 0
	parent.velocity = Vector2.ZERO

func exit() -> void:
	super()

## An Idle player should be able to enter the jump, move, and dash states
## depending on the input and location of the parent body
func process_input(_event: InputEvent) -> State:
	if parent.is_on_floor() and move_stats.max_jumps > move_stats.jumps_used:		
		# move to jump State (Must be on the floor)
		if get_jump_input():
			return jump_state
			
		# move to the move state (Must be on floor)
		if get_movement_input():
			# Move to the dash_state. Have to give a direction of the dash
			if check_dash_conditions():
				return dash_state
			# if dash not requested the go to move state
			return move_state
			
	return null


func process_physics(delta: float) -> State:
	# Check if the actor is not on the floor to see if they are falling.
	# Since an idle player should never move this should be the only check needed
	if !parent.is_on_floor(): 
		return fall_state
	return null
