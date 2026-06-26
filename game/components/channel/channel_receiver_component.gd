class_name ChannelReceiverComponent extends Node
## Reports when this [member channel]'s buttons activate or deactivate.
##
## Connects to [SignalHub]'s button signals and re-emits the ones matching its
## channel, distinguishing a permanent pedestal activation from a pressure plate.

## Emitted when a same-channel button activates. [param by_pedestal] is true for a
## (permanent) pedestal, false for a (held) pressure plate.
signal activated(by_pedestal: bool)
## Emitted when a same-channel pressure plate is released.
signal deactivated

@export var channel: Channel.Type

func _ready() -> void:
	SignalHub.pedestal_activated.connect(_on_pedestal)
	SignalHub.pressure_plate_activated.connect(_on_plate_activated)
	SignalHub.pressure_plate_deactivated.connect(_on_plate_deactivated)

func _on_pedestal(ch: Channel.Type) -> void:
	if ch == channel:
		activated.emit(true)

func _on_plate_activated(ch: Channel.Type) -> void:
	if ch == channel:
		activated.emit(false)

func _on_plate_deactivated(ch: Channel.Type) -> void:
	if ch == channel:
		deactivated.emit()
