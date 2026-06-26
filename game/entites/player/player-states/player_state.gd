class_name PlayerState extends FSMState2D
## Base for the player's FSM states.
##
## The machine injects the [Player] as [member FSMState2D.body]. States decide
## transitions and set movement [i]intent[/i] on the player's movement components
## (`walk`, `jump`, `dash`, `gravity`); they never call move_and_slide — the
## [LocomotionComponent] owns that.

## Animation played on [method enter] (if set). Assigned per state in the scene.
@export var animation_name: String

var player: Player:
	get: return body as Player
var move_stats: MoveStats:
	get: return player.movement_stats
var sprite: AnimatedSprite2D:
	get: return player.sprite
var input: InputComponent:
	get: return player.input
var walk: WalkComponent:
	get: return player.walk
var jump: JumpComponent:
	get: return player.jump
var dash: DashComponent:
	get: return player.dash
var gravity: GravityComponent:
	get: return player.gravity

func enter() -> void:
	if animation_name and sprite:
		sprite.play(animation_name)

func get_jump_input() -> bool:
	return input.get_jump()

func get_movement_input() -> bool:
	return input.get_move()

func get_left_input() -> bool:
	return input.get_left()

func get_right_input() -> bool:
	return input.get_right()

func get_fastfall_input() -> bool:
	return input.get_fast_fall()

func get_dash_input() -> bool:
	return input.get_dash()

## True when the player is asking to dash and the dash is available.
func check_dash_conditions() -> bool:
	return get_dash_input() and dash.can_dash()
