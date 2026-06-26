class_name MoveStats extends Resource
## A Resource that is used to asign how an object can move.
## 
## Used in tandem with the [StateMachine].
## Can act as a kinda template allowing different actors to have different types of movement
## Acts as a sort of structure that all states can access to determine what state should be move to 
## Since this is a custom resource things like Timers can not be added as children
@export_category("Enemy Movement types")
@export_subgroup("Move types")
@export var can_move: bool = false
@export var can_idle: bool = false

@export_subgroup("Timers")
@export var idle_time : float = 4
@export var move_time : float = 4
@export var starting_dir : int = 1

@export_category("Movement Stats")
@export_subgroup("Movment type")
@export var advanced_movement: bool ## if true, acceleration and decceleration will be used
@export var multi_jump: bool
@export var enable_dash: bool

@export_subgroup("Speed Stats")
@export var ground_speed: float = 100
@export var air_speed: float = 50

@export_subgroup("Acceleration Stats")
@export var ground_acceleration: float = 80
@export var air_acceleration: float = 20

@export_subgroup("Decceleration Stats")
@export var ground_decceleration: float = 50
@export var air_decceleratoin: float = 80

@export_subgroup("Gravity Stats")
@export var gravity: float = 980
@export var fast_fall_gravity: float = 1500

@export_subgroup("Jump Stats")
@export var jump_height: float = -400
@export var max_jumps: int = 1
@export var multi_jump_height_multiplier: float = 0.8
@export var coyote_jump_time: float = 0.5
@export var jump_buffer_time: float = 0.2
var jumps_used: int = 0
var can_coyote_jump: bool
var is_jump_buffered: bool

@export_subgroup("Dash Stats")
@export var dash_multipler: float = 2.0
@export var dash_duration: float = 2.0
@export var dash_cooldown: float = 4.0
@export var dash_distance: float = 100
var is_dash_ready: bool = true
var is_dashing: bool
var dash_timer: float = 0
var dash_cooldown_timer: float = 0
var dash_start_position: float = 0.0
var was_dashing: bool = false


func handle_horizontal_input(body: CharacterBody2D, direction: float, delta: float) -> void:
	var s = get_speed(body)
	var a = get_acceleration(body)
	var d = get_decceleration(body)
	
	if was_dashing:
		was_dashing = false  # Reset the flag
		body.velocity.x = direction * s  # Instantly set velocity
		return  # Exit early to prevent move_toward smoothing
	
	if direction != 0: # Player is moving
		if advanced_movement:
			body.velocity.x = move_toward(body.velocity.x, direction * s, a * delta)
		else:
			body.velocity.x = direction * s
	elif direction == 0: # Player is stoping
		if advanced_movement:
			body.velocity.x = move_toward(body.velocity.x, 0, d * delta)
		else:
			body.velocity.x = 0

			
func handle_gravity(body: CharacterBody2D, fast_fall: bool, delta: float) -> void:
	if not body.is_on_floor():
		if fast_fall:
			body.velocity.y += fast_fall_gravity * delta
		else:
			body.velocity.y += gravity * delta

			
func handle_jump(body: CharacterBody2D) -> void:
	if jumps_used == 0:
		body.velocity.y = jump_height
	else:
		body.velocity.y = jump_height * multi_jump_height_multiplier
	jumps_used += 1

	
func handle_dash(body: CharacterBody2D, direction: float, delta: float):
	if enable_dash:
		# Decrease the dash timer
		dash_timer -= delta
		# calculate the new position
		var new_position: float = direction * get_speed(body) * dash_multipler
		body.velocity.x = new_position
		is_dash_ready = false


# Getters --------------------------------------------------------------------------------------------------------
# used to determine which of the variables to use based on the state of the character
func get_speed(body: CharacterBody2D) -> float:
	return ground_speed if body.is_on_floor() else air_speed

func get_acceleration(body: CharacterBody2D) -> float:
	return ground_acceleration if body.is_on_floor() else air_acceleration

func get_decceleration(body: CharacterBody2D) -> float:
	return ground_decceleration if body.is_on_floor() else air_decceleratoin

func get_direction(body: CharacterBody2D) -> float:
	return 1 if body.velocity.x > 0 else -1
