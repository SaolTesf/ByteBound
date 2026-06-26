@abstract
extends Node
class_name IFSMState
## Contract every state must fulfill.
##
## A state belongs to an [IFSMachine] and controls a [member _parent] node.
## The dimensional variants [FSMState2D] and [FSMState3D] expose a typed accessor
## for that node; the base [FSMState] keeps it as a plain [Node].

#region Exports
@export var state_name: String ## Key this state is registered under in the machine.

@export_group("Debug")
@export var LOGLVL: int = 2
@export var DEBUGLVL: int = 1
#endregion

#region Public Members
var machine: IFSMachine ## The machine this state belongs to.
#endregion

#region Private Members
var _parent: Node ## The node this state controls. Set by the machine on init.
#endregion

#region Abstract API
@abstract func enter() -> void ## What happens immediately when a state is entered.
@abstract func exit() -> void ## What happens right before a state is exited.
## Handles the state's input logic. Return the next [FSMState] to transition, or null.
@abstract func process_input(event: InputEvent) -> FSMState
## Runs every frame. Return the next [FSMState] to transition, or null.
@abstract func process_frame(delta: float) -> FSMState
## Runs every physics step. Return the next [FSMState] to transition, or null.
@abstract func process_physics(delta: float) -> FSMState
#endregion
