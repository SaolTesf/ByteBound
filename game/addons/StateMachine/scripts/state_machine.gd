extends IFSMachine
class_name FSMachine
## Default state machine for plain [Node] owners.
##
## Implements the standard dispatch policy: forward each callback to the current
## state and transition to whatever [FSMState] it returns. The machine drives
## itself (see [IFSMachine]); the controlled node defaults to its parent or
## [member IFSMachine.target]. For typed owners use [FSMachine2D] or [FSMachine3D].

#region Public API
## Forwards a frame to the current state and transitions if it returns a state.
func process_frame(delta: float) -> void:
	var new_state: FSMState = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)


## Forwards a physics step to the current state and transitions if it returns a state.
func process_physics(delta: float) -> void:
	var new_state: FSMState = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)


## Forwards input to the current state and transitions if it returns a state.
func process_input(event: InputEvent) -> void:
	var new_state: FSMState = current_state.process_input(event)
	if new_state:
		change_state(new_state)
#endregion
