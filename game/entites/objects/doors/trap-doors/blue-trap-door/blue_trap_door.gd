class_name BlueTrapDoor extends StaticBody2D
## A trap door that opens while its channel's pressure plate is held, then shuts
## a moment after it is released.
##
## Thin coordinator: wires a [ChannelReceiverComponent] to the door's animation
## and collision. Ignores pedestal activations (only pressure plates open it).

@export var receiver: ChannelReceiverComponent
@export var sprite: AnimatedSprite2D
@export var collision: CollisionShape2D

var is_open: bool = false
var is_transitioning: bool = false
var door_timer: Timer

func _ready() -> void:
	sprite.play("Idle")
	sprite.animation_finished.connect(_on_animation_finished)
	door_timer = Timer.new()
	door_timer.one_shot = true
	add_child(door_timer)
	door_timer.timeout.connect(_on_door_timer_timeout)
	receiver.activated.connect(_on_activated)
	receiver.deactivated.connect(_on_deactivated)

func _on_activated(by_pedestal: bool) -> void:
	if by_pedestal:
		return  # only pressure plates open the trap door
	if not is_open and not is_transitioning:
		is_transitioning = true
		sprite.play("Open")
		door_timer.stop()

func _on_deactivated() -> void:
	door_timer.start(1)

func _on_door_timer_timeout() -> void:
	if is_open and not is_transitioning:
		is_transitioning = true
		sprite.play("Shut")

func _on_animation_finished() -> void:
	if sprite.animation == "Open":
		is_open = true
		is_transitioning = false
		collision.set_deferred("disabled", true)
	elif sprite.animation == "Shut":
		is_open = false
		is_transitioning = false
		collision.set_deferred("disabled", false)
