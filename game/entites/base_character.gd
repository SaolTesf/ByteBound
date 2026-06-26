class_name BaseCharacter extends ICharacter
## Shared base for the game's characters.
##
## Implements [ICharacter] and holds the component slots common to every
## character: an [AnimatedSprite2D] and a [MoveStats] resource. Drives the shared
## horizontal sprite flip from [member dir]. Concrete characters ([Player],
## [Enemy]) extend this and add their own components and behaviour.

@export var sprite: AnimatedSprite2D
@export var movement_stats: MoveStats

## Facing/movement direction (-1 left, 1 right). Updated by input or AI.
var dir: int

func _ready() -> void:
	assert(sprite, "BaseCharacter: sprite (AnimatedSprite2D) is not set")
	assert(movement_stats, "BaseCharacter: movement_stats (MoveStats) is not set")

func _physics_process(_delta: float) -> void:
	sprite.flip_h = dir < 0

func get_move_stats() -> MoveStats:
	return movement_stats

func get_sprite() -> AnimatedSprite2D:
	return sprite
