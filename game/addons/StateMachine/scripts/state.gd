extends IFSMState
class_name FSMState
## Basic concrete state with empty default behavior.
##
## Override the methods you need. [method enter] and [method exit] default to
## no-ops; the [code]process_*[/code] methods default to returning [code]null[/code]
## (no transition). Use [FSMState2D] or [FSMState3D] when you want a typed parent node.

#region Public API
## What happens immediately when a state is entered.
func enter() -> void:
	pass


## What happens right before a state is exited.
func exit() -> void:
	pass


## Handles the state's input logic. Return the next [FSMState] to transition, or null.
func process_input(_event: InputEvent) -> FSMState:
	return null


## Runs every frame. Return the next [FSMState] to transition, or null.
func process_frame(_delta: float) -> FSMState:
	return null


## Runs every physics step. Return the next [FSMState] to transition, or null.
func process_physics(_delta: float) -> FSMState:
	return null
#endregion
