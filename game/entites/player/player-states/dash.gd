class_name PlayerDash extends PlayerState
## DASH STATE
##
## Locks the player into a direction for a fixed duration, then returns to
## move/idle/fall and puts the dash on cooldown.

@export_category("Nodes")
@export var move_state: FSMState
@export var idle_state: FSMState
@export var fall_state: FSMState

var direction: float

func enter() -> void:
	super()
	get_direction()
	move_stats.dash_timer = move_stats.dash_duration

func exit() -> void:
	move_stats.dash_cooldown_timer = move_stats.dash_cooldown
	move_stats.is_dash_ready = false
	move_stats.was_dashing = true
	player.move_and_slide()

func process_frame(delta: float) -> FSMState:
	move_stats.dash_timer -= delta
	return null

func process_physics(delta: float) -> FSMState:
	move_stats.handle_dash(player, direction, delta)
	player.velocity.y = 0
	player.move_and_slide()
	if move_stats.dash_timer <= 0 and get_movement_input():
		return move_state
	if move_stats.dash_timer <= 0 and not get_movement_input():
		return idle_state
	if player.velocity.y > 0 and not player.is_on_floor():
		return fall_state
	return null

func get_direction() -> void:
	if get_left_input():
		direction = -1.0
	elif get_right_input():
		direction = 1.0
