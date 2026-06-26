@abstract
class_name MovementComponent extends Node
## A single velocity contributor run by a [LocomotionComponent].
##
## The locomotion runs each contributor's [method apply] in tree order every
## physics frame, then calls move_and_slide once. Continuous contributors
## (gravity, walk) do their work in [method apply]; triggered ones (jump, dash)
## expose extra methods the controller calls and may use [method apply] for
## per-frame upkeep.

## Contributes to [param body]'s velocity for this physics frame.
@abstract func apply(body: CharacterBody2D, delta: float) -> void
