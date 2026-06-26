class_name PlayerDash extends State
## DASH STATE
##
## In the Dash state the player should be locked in to a direction for a set amount of time.
## Once the dash is over it needs to go on a cooldown
@export_category("Nodes")
@export var move_state: State
@export var idle_state: State
@export var fall_state: State

var direction: float

func enter() -> void:
	super()
	Debug.debug(self, "Player Entered the Dash State", false)
	get_direction()
	move_stats.dash_timer = move_stats.dash_duration

	
func exit() -> void:
	super()
	move_stats.dash_cooldown_timer = move_stats.dash_cooldown
	move_stats.is_dash_ready = false
	move_stats.was_dashing = true
	parent.move_and_slide()


func process_frame(delta: float) -> State:
	move_stats.dash_timer -= delta
	return null


func process_physics(delta: float) -> State:
	move_stats.handle_dash(parent, direction, delta)
	parent.velocity.y = 0
	parent.move_and_slide()
	if move_stats.dash_timer <= 0 and get_movement_input():
		return move_state
	if move_stats.dash_timer <= 0 and !get_movement_input():
		return idle_state
	if parent.velocity.y > 0 and !parent.is_on_floor():
		return fall_state
	return null


func get_direction() -> void:
	if get_left_input():
		direction = -1.0
	elif get_right_input():
		direction = 1.0
