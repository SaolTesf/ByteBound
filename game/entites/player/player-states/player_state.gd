class_name PlayerState extends FSMState2D
## Base for the player's FSM states.
##
## The machine injects the controlled node as [member FSMState2D.body] — here the
## [Player]. This base exposes the player's [MoveStats], sprite, and
## [InputComponent], plus input-intent helpers, so concrete states stay focused
## on movement and transition logic.

## Animation played on [method enter] (if set). Assigned per state in the scene.
@export var animation_name: String

## The controlled player, typed.
var player: Player:
	get: return body as Player

## The player's movement stats resource.
var move_stats: MoveStats:
	get: return player.movement_stats

## The player's animated sprite.
var sprite: AnimatedSprite2D:
	get: return player.sprite

## The player's input component.
var input: InputComponent:
	get: return player.input

## Plays this state's animation (when one is assigned) on entry.
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
	return get_dash_input() and move_stats.is_dash_ready and move_stats.enable_dash
