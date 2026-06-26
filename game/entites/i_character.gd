@abstract
class_name ICharacter extends CharacterBody2D
## Contract every character (the [Player], the [Enemy]) must fulfil.
##
## A character exposes its movement stats and animated sprite. Concrete
## characters extend [BaseCharacter], which implements this contract and wires
## up the shared component slots.

## Returns the character's movement stats resource.
@abstract func get_move_stats() -> MoveStats

## Returns the character's animated sprite.
@abstract func get_sprite() -> AnimatedSprite2D
