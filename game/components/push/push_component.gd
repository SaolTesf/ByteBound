class_name PushComponent extends MovementComponent
## Pushes the body horizontally while the player is in contact (via [member hitbox]).
##
## A movement component run by a [LocomotionComponent]: while a pusher touches the
## hitbox it drives velocity.x away from them (force scaled by their speed);
## otherwise it decelerates. Emits [signal SignalHub.movable_box_hit] on contact.

@export var body: CharacterBody2D
@export var hitbox: Hitbox
@export var acceleration: float = 10.0
@export var max_push_force: float = 80.0
@export var friction: float = 6.0

var _pusher: CharacterBody2D

func _ready() -> void:
	hitbox.init()
	hitbox.entered.connect(_on_hitbox_entered)
	hitbox.exited.connect(_on_hitbox_exited)

func apply(_body: CharacterBody2D, delta: float) -> void:
	if _pusher:
		var dir := -signf(_pusher.global_position.x - body.global_position.x)
		var force := clampf(_pusher.velocity.length() * 1.5, 30.0, max_push_force)
		body.velocity.x = lerpf(body.velocity.x, dir * force, acceleration * delta)
	else:
		body.velocity.x = lerpf(body.velocity.x, 0.0, friction * delta)

func _on_hitbox_entered(b: Node2D) -> void:
	if b.is_in_group("Player"):
		_pusher = b as CharacterBody2D
		SignalHub.movable_box_hit.emit(body)

func _on_hitbox_exited(b: Node2D) -> void:
	if b == _pusher:
		_pusher = null
