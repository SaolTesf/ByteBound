class_name MoveStats extends Resource
## Pure data describing how a character can move.
##
## Behaviour lives in the movement components ([WalkComponent], [JumpComponent],
## [DashComponent]) which read these values; gravity values live on
## [GravityComponent]. A character points its movement components at one of these
## resources.

@export_category("AI movement")
@export var can_move: bool = false
@export var can_idle: bool = false
@export var idle_time: float = 4
@export var move_time: float = 4
@export var starting_dir: int = 1

@export_category("Movement")
@export var advanced_movement: bool ## acceleration/deceleration are used when true
@export var multi_jump: bool
@export var enable_dash: bool

@export_subgroup("Speed")
@export var ground_speed: float = 100
@export var air_speed: float = 50

@export_subgroup("Acceleration")
@export var ground_acceleration: float = 80
@export var air_acceleration: float = 20

@export_subgroup("Deceleration")
@export var ground_deceleration: float = 50
@export var air_deceleration: float = 80

@export_subgroup("Jump")
@export var jump_height: float = -400
@export var max_jumps: int = 1
@export var multi_jump_height_multiplier: float = 0.8
@export var coyote_jump_time: float = 0.5
@export var jump_buffer_time: float = 0.2

@export_subgroup("Dash")
@export var dash_multiplier: float = 2.0
@export var dash_duration: float = 2.0
@export var dash_cooldown: float = 4.0
@export var dash_distance: float = 100
