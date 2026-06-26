class_name ThrowComponent extends Node
## Throws the held body in the holder's facing direction on "throw".
##
## Pairs with a sibling [PickupComponent]: when the body is held and "throw" is
## pressed, it drops the body with a launch impulse.

signal thrown

@export var pickup: PickupComponent
@export var throw_force: Vector2 = Vector2(300, 300)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw") and pickup.is_held:
		var dir := pickup.holder.facing_direction()
		pickup.drop(Vector2(dir * throw_force.x, -throw_force.y))
		thrown.emit()
