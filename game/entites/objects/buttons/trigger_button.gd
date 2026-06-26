@abstract
class_name TriggerButton extends Area2D
## Base for interactable buttons (pedestals, pressure plates).
##
## A button belongs to a colour [member type] and toggles the [Laser] on the same
## channel via [SignalHub]. Concrete buttons implement [method emit_activation] to
## broadcast their specific event. Sprite animations: "Idle", "Activate",
## "Deactivate". Every button joins the "Buttons" group.

## The colour channel this button controls. Set per scene.
@export var type: Channel.Type
@export var light: PointLight2D

var is_activated: bool = false
var sprite: AnimatedSprite2D

func _ready() -> void:
	add_to_group("Buttons")
	sprite = find_child("AnimatedSprite2D")
	light = find_child("PointLight2D")
	assert(sprite, "TriggerButton: AnimatedSprite2D not found")

## Broadcasts this button's (de)activation over [SignalHub].
@abstract func emit_activation() -> void
