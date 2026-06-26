class_name ChannelEmitterComponent extends Node
## A button that broadcasts its [member channel] over [SignalHub] on activation.
##
## Detects qualifying bodies via the owning [Area2D]. Latching buttons (pedestals)
## activate once and stay; non-latching ones (pressure plates) deactivate when
## the last qualifying body leaves. Configures pedestal vs plate by data, not type.

const BUTTON_INTERACT: AudioPoolStream = preload("res://Assets/Audio/pool-streams/buttonInteract.tres")
const PLATE_STEPPED: AudioPoolStream = preload("res://Assets/Audio/pool-streams/plateStepped.tres")

signal activated
signal deactivated

@export var area: Area2D
@export var sprite: AnimatedSprite2D
@export var light: PointLight2D
@export var channel: Channel.Type
## Pedestals latch (stay activated); pressure plates do not.
@export var latch: bool = false
## Groups whose bodies trigger this button.
@export var trigger_groups: Array[String] = ["Player"]

var is_activated: bool = false

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	if not latch:
		area.body_exited.connect(_on_body_exited)

func _on_body_entered(b: Node2D) -> void:
	if not is_activated and _qualifies(b):
		is_activated = true
		sprite.play("Activate")
		if light:
			light.enabled = false
		_broadcast()
		activated.emit()

func _on_body_exited(b: Node2D) -> void:
	if is_activated and _qualifies(b):
		is_activated = false
		sprite.play("Deactivate")
		_broadcast()
		deactivated.emit()

func _broadcast() -> void:
	if latch:
		AudioPool.play(BUTTON_INTERACT, area.global_position)
		SignalHub.pedestal_activated.emit(channel)
	else:
		AudioPool.play(PLATE_STEPPED, area.global_position)
		if is_activated:
			SignalHub.pressure_plate_activated.emit(channel)
		else:
			SignalHub.pressure_plate_deactivated.emit(channel)

func _qualifies(b: Node2D) -> bool:
	for g in trigger_groups:
		if b.is_in_group(g):
			return true
	return false
