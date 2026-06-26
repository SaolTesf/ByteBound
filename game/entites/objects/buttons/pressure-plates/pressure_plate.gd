class_name PressurePlate extends TriggerButton
## A pressure plate deactivates its channel's [Laser] only while something rests
## on it; the laser re-activates when the plate is cleared.
##
## Triggered by the player, throwables, or movable boxes.

func _ready() -> void:
	super._ready()
	add_to_group("PressurePlates")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	Debug.debug(self, "%s entered the pressure plate" % body.name, false)
	if _is_trigger(body) and not is_activated:
		sprite.play("Activate")
		light.enabled = false
		is_activated = true
		emit_activation()

func _on_body_exited(body: Node2D) -> void:
	Debug.debug(self, "%s left the pressure plate" % body.name, false)
	if _is_trigger(body):
		sprite.play("Deactivate")
		is_activated = false
		emit_activation()

func emit_activation() -> void:
	AudioController.play_sound("PlateStepped")
	if is_activated:
		SignalHub.pressure_plate_activated.emit(type)
	else:
		SignalHub.pressure_plate_deactivated.emit(type)

func _is_trigger(body: Node2D) -> bool:
	return body.is_in_group("Player") or body.is_in_group("Throwable") or body.is_in_group("Movable")
