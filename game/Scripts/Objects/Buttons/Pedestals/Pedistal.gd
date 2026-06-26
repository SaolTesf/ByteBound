class_name Pedestal extends TriggerButton
## This is the base class for all pedistals.
##
## Each pedistal will need a refrence to its animated sprite to change its animation.
## Each pedistal will emit a signal based on the type of pedistal it is.
## For this we use a enum to define the type of the pedistal. (Set this for each subclass)
## The pedistal will emit a signal when the player enters the area. (call signal_emiter() in the subclass)

func _ready() -> void:
	super._ready()
	# Add the pedistal to the "Pedistals" group
	add_to_group("Pedistals")
	body_entered.connect(_on_body_entered)
	


func _on_body_entered(body: Node2D) -> void:
	Debug.debug(self, "%s Entered the buttons Area2D" % body.name, false)
	if body.is_in_group("Player"):
		# Only emit the signal if the button is not already activated
		# Keeps the signal from emiting more then once per entering.
		if not is_activated:
			# Play the transition animation (button being pressed)
			sprite.play("Activate")
			light.enabled = false
			
			# Set before the signal is emitted
			# Makes sure that on entering the activated signal is emitted
			is_activated = true

			# emit the proper signal
			signal_emiter()

	
## Emits a signal based on the type of pedestals
func signal_emiter() -> void:
	AudioController.play_sound("ButtonInteract")
	if type != Globals.ButtonType.DEFAULT:
		SignalHub.emit_pedistal_activated(type)
