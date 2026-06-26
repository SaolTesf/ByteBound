class_name State extends Node
## States are nodes that are managed by the [StateMachne]
##
## The state class is supposed to represent a self contained set of behaviors (states)
## Examples of this is a jump state would contain all the logic to allow an object to jump
## @experimental

@export_category("Bases State Settings")
@export var animation_name: String

# refrences that are passed down from the StateMachine
var parent: CharacterBody2D
var sprite: AnimatedSprite2D
var input: InputComponent
var move_stats: MoveStats

## What should the state do immediatly upon being entered.
func enter():
	if animation_name: 
		sprite.play(animation_name)

## if there is anything the state needs to do or reset before swapping to a new state
func exit():
	pass
	
## Process frame is similar to the _process function
## Should be used to handle non physics checks
func process_frame(_delta: float) -> State:
	return null

## Process Physics is similar to _Physiscs_process
## Should be used to move the parent and physcs related checks
func process_physics(_delta: float) -> State:
	return null

## Handles all input given. Checks if any of the input should change the state
func process_input(_event: InputEvent) -> State:
	return null

# Movement --------------------------------------------------------------------
# Functions to allow overriding of movement input,
# by default these are set to the input component
# and in the future I might try to change the input class to be more abstract
func get_movement_input() -> bool:
	return input.get_move()

func get_jump_input() -> bool:
	return input.get_jump()

func get_left_input() -> bool:
	return input.get_left()

func get_right_input() -> bool:
	return input.get_right()

func get_fastfall_input() -> bool:
	return input.get_fast_fall()

func get_dash_input() -> bool:
	return input.get_dash()

func get_grab_input() -> bool:
	return input.get_interact()

func get_throw_input() -> bool:
	return input.get_throw()

func check_dash_conditions() -> bool:
	return get_dash_input() and move_stats.is_dash_ready and move_stats.enable_dash
