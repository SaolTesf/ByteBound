class_name HolderComponent extends Node2D
## A hold point on a character that carries one item at a time.
##
## Flips to the character's facing side and tracks the single held item;
## [PickupComponent]s grab/release through it so only one item is held at once.

@export var body: CharacterBody2D

var on_right_side: bool = true
var held: Node

func init(b: CharacterBody2D) -> void:
	body = b

## Flips the hold point to the side the character last moved toward.
func update_direction(input: InputComponent) -> void:
	if input.get_left():
		on_right_side = false
	if input.get_right():
		on_right_side = true
	position.x = abs(position.x) if on_right_side else -abs(position.x)

func is_free() -> bool:
	return held == null

func grab(item: Node) -> void:
	held = item

func release() -> void:
	held = null

## 1 when facing right, -1 when facing left.
func facing_direction() -> int:
	return 1 if on_right_side else -1
