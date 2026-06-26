class_name StateMachine extends Node

@export var inital_state: State
var _current_state: State

func init(parent: CharacterBody2D, sprite: AnimatedSprite2D,
	move_stats: MoveStats, input: InputComponent = null) -> void:
	for child : State in get_children():
		child.parent = parent
		child.sprite = sprite
		child.input = input
		child.move_stats = move_stats
	
	_current_state = inital_state
	_current_state.enter()

func change_state(new_state:State):
	if _current_state:
		_current_state.exit()
	
	_current_state = new_state
	_current_state.enter()
	
func process_frame(delta: float) -> void:
	var new_state: State = _current_state.process_frame(delta)
	if new_state:
		#_current_state = new_state
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state: State = _current_state.process_physics(delta)
	if new_state:
		#_current_state = new_state
		change_state(new_state)
	
func process_input(event: InputEvent) -> void:
	var new_state: State = _current_state.process_input(event)
	if new_state:
		#_current_state = new_state
		change_state(new_state)
