class_name AnimationComponent extends Node
## Handles animating an [AnimatedSprite2D]
##
## this component should handle transitions from one animation to another
## this requires that animations of all nodes must follow the same naming convention. [br]
## the current animaiton names that should be used are: [br]
## 		- Idle [br]
## 		- Move [br]
##		- Jump [br]
##		- Fall [br]
##		- Death [br]
## TODO: abstract this in a way such that animation names can be arbitary.

@export_category("Nodes")
## Attach the sprite of the parent node to this refrence.
@export  var sprite : AnimatedSprite2D

## Flips the animation based on the direction that was passed in.
## in a 2D game we only worry about [member AnimatedSprite2D.flip_h] 
func handle_horizontal_flip(move_direction : float):
	if move_direction == 0:
		return
	
	sprite.flip_h = false if move_direction > 0 else true

## This function handles changing the animation based on the ground movement
## Call this function in the [method Node2D._process_physics]
func handle_move_animation(move_direction : float) -> void:
	handle_horizontal_flip(move_direction)
	
	if move_direction != 0:
		sprite.play("Move")
	else:
		sprite.play("Idle")

## This function handles changing the animation based on the velocity.y movement
## Call this function in the [method Node2D._process_physics]
func handle_jump_animation(is_jumping : bool, is_falling : bool):
	if is_jumping:
		sprite.play("Jump")
	if is_falling:
		sprite.play("Fall")

## Plays a death animation. Call whenever a game_object should die
func play_death_animation() -> void:
	sprite.play("Death")
