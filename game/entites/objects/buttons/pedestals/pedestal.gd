class_name Pedestal extends TriggerButton
## A pedestal permanently activates its channel's [Laser] when the player steps
## onto it. Activates once and stays activated.

func _ready() -> void:
	super._ready()
	add_to_group("Pedestals")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	Debug.debug(self, "%s entered the pedestal" % body.name, false)
	if body.is_in_group("Player") and not is_activated:
		sprite.play("Activate")
		light.enabled = false
		is_activated = true
		emit_activation()

func emit_activation() -> void:
	AudioController.play_sound("ButtonInteract")
	SignalHub.pedestal_activated.emit(type)
