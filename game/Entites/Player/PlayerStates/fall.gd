class_name PlayerFall extends State

@export_category("Transitions")
@export_subgroup("States")
@export var move_state: State
@export var idle_state: State
@export var jump_state: State
@export var dash_state: State

var jump_buffer_time: float
var coyote_time: float 
var _jump_buffer_timer: float
var _coyote_timer: float

func enter() -> void:
	Debug.debug(self, "Player Entered the Fall State\nJumps Used: %d" % move_stats.jumps_used , false)
	super.enter()
	set_up_player_corrections()



func exit() -> void:
	super.exit()

func process_frame(delta: float) -> State:
	_jump_buffer_timer -= delta
	_coyote_timer -= delta
	return

func process_input(event: InputEvent) -> State:
	# Handle multi Jumps
	if move_stats.multi_jump and !parent.is_on_floor() and !parent.is_on_wall():
		if move_stats.max_jumps > move_stats.jumps_used:
			if get_jump_input():
				return jump_state
	
	if check_dash_conditions():
		return dash_state
	
	# Handle Coyote Time
	if get_jump_input() and _coyote_timer > 0:
		print("DEBUG: Fallstate used coyote jump.")
		return jump_state
	
	# Handle the jump buffering
	if get_jump_input():
		_jump_buffer_timer = jump_buffer_time
		
	return null

func process_physics(delta: float) -> State:
	move_stats.handle_gravity(parent, get_fastfall_input(), delta)
	move_stats.handle_horizontal_input(parent, input.input_horizontal, delta)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if !get_movement_input() and _jump_buffer_timer < 0:
			return idle_state
		if get_movement_input() and _jump_buffer_timer < 0:
			return move_state
		if _jump_buffer_timer > 0:
			return jump_state
	return null

func set_up_player_corrections() -> void:
	coyote_time = move_stats.coyote_jump_time
	jump_buffer_time = move_stats.jump_buffer_time
	_jump_buffer_timer = 0
	_coyote_timer = 0
