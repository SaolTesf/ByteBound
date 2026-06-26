@abstract
extends Node
class_name IFSMachine
## Shared plumbing for a node-based finite state machine.
##
## Holds the current/last state, the controlled [member target] node, and the
## enable flags. The machine drives itself through the engine callbacks
## ([method _process], [method _physics_process], [method _unhandled_input]) so
## owners do not have to forward anything. Subclasses implement the dispatch
## policy via the abstract [code]process_*[/code] methods (see [FSMachine]).

#region Exports
@export var starting_state: FSMState ## The state the machine will start in.
## The node the states control. Defaults to [method Node.get_parent] when left null.
@export var target: Node

@export_group("Debug")
## used for debugging in a logging system if implemented
@export var LOGLVL: int = 1
#endregion

#region Private Members
var _parent: Node # The node the states control.
var _current_state: FSMState # what is the current state
var _last_state: FSMState # what was the last state
var _state_list: Dictionary[String, FSMState] # what are the states
var _initialized: bool # has init() already run

# private internal variables
var _enabled := true
var _physics_enabled := true
var _process_enabled := true
var _input_enabled := true
#endregion

#region Public Members
## The current state the machine is in.
var current_state: FSMState:
	get: return _current_state
	set(v): _current_state = v

## The last state the machine was in.
var last_state: FSMState:
	get: return _last_state
	set(v): _last_state = v

## Whether the machine is enabled. Disabling halts all processing.
var enabled: bool:
	get: return _enabled
	set(v): enable(v)

## Whether the machine's physics process is enabled.
var physics_enabled: bool:
	get: return _physics_enabled
	set(v): _physics_enabled = v

## Whether the machine's frame process is enabled.
var process_enabled: bool:
	get: return _process_enabled
	set(v): _process_enabled = v

## Whether the machine's input process is enabled.
var input_enabled: bool:
	get: return _input_enabled
	set(v): _input_enabled = v

## A list of the child states of the machine, keyed by [member IFSMState.state_name].
var state_list: Dictionary[String, FSMState]:
	get:
		_state_list = get_states()
		return _state_list
#endregion

#region Engine Methods
func _ready() -> void:
	if _initialized:
		return
	init(target if target else get_parent())


func _process(delta: float) -> void:
	if _enabled and _process_enabled:
		process_frame(delta)


func _physics_process(delta: float) -> void:
	if _enabled and _physics_enabled:
		process_physics(delta)


func _unhandled_input(event: InputEvent) -> void:
	if _enabled and _input_enabled:
		process_input(event)
#endregion

#region Public API
## Wires the child states to this machine, assigns the controlled [param parent],
## and enters [member starting_state]. Called automatically from [method _ready];
## call manually only to re-target the machine.
func init(parent: Node) -> void:
	_parent = parent
	for s in get_states().values():
		var child_state: FSMState = s as FSMState
		child_state.machine = self
		child_state._parent = _parent

	if starting_state == null:
		push_error("FSMachine needs a starting_state.")
		return

	_initialized = true
	_force_change_state(starting_state)


## Changes states, unless the machine is disabled.
func change_state(s: FSMState) -> void:
	if not enabled:
		return
	_force_change_state(s)


## Enables or disables the machine. Disabling stops process, physics, input, and
## state changes, and exits the current state.
func enable(v: bool) -> void:
	if _enabled == v:
		return
	_enabled = v
	if not _enabled:
		_physics_enabled = false
		_process_enabled = false
		_input_enabled = false
		if current_state:
			current_state.exit()


## Gets all the child states of the machine, keyed by [member IFSMState.state_name].
func get_states() -> Dictionary[String, FSMState]:
	var rv: Dictionary[String, FSMState] = {}
	for s in get_children():
		if s is FSMState:
			rv.set(s.state_name, s)
	return rv
#endregion

#region Private Helpers
## Forces a state change even if the machine is disabled. For internal use;
## prefer [method change_state].
func _force_change_state(state: FSMState) -> void:
	if _current_state:
		_current_state.exit()

	_last_state = _current_state
	_current_state = state
	_current_state.enter()
#endregion

#region Abstract API
@abstract func process_frame(_delta: float) -> void ## Dispatch a frame to the current state.
@abstract func process_physics(_delta: float) -> void ## Dispatch a physics step to the current state.
@abstract func process_input(_event: InputEvent) -> void ## Dispatch input to the current state.
#endregion
