class_name Laser extends Area2D
## A hazard beam that kills the player on contact while active.
##
## Belongs to a colour [member type]; pedestals and pressure plates on the same
## channel toggle it via [SignalHub]. A pedestal opens it permanently; a pressure
## plate opens it only while held down.

## The colour channel this laser responds to. Set per scene.
@export var type: Globals.Channel

var sprite: AnimatedSprite2D
var light: PointLight2D
var is_active: bool = true
var perma_open: bool = false
# Set when reactivated so _process replays "Active" after the "Activate" anim.
var just_activated: bool = false

func _ready() -> void:
	sprite = find_child("AnimatedSprite2D")
	light = find_child("PointLight2D")
	assert(sprite, "Laser: AnimatedSprite2D not found")
	assert(light, "Laser: PointLight2D not found")

	sprite.play("Active")
	light.enabled = true
	AudioController.play_sound("LaserField")

	body_entered.connect(_on_body_entered)
	SignalHub.pedestal_activated.connect(_on_pedestal_activated)
	SignalHub.pressure_plate_activated.connect(_on_pressure_plate_activated)
	SignalHub.pressure_plate_deactivated.connect(_on_pressure_plate_deactivated)

func _process(_delta: float) -> void:
	if not sprite.is_playing() and just_activated:
		sprite.play("Active")
		just_activated = false
	_update_sound()

#region Signal handlers
func _on_pedestal_activated(channel: Globals.Channel) -> void:
	if channel != type:
		return
	perma_open = true
	if is_active:
		_deactivate()

func _on_pressure_plate_activated(channel: Globals.Channel) -> void:
	if channel != type:
		return
	if is_active and not perma_open:
		_deactivate()

func _on_pressure_plate_deactivated(channel: Globals.Channel) -> void:
	if channel != type:
		return
	if not is_active and not perma_open:
		_activate()

func _on_body_entered(body: Node) -> void:
	Debug.debug(self, "%s entered the laser" % body.name, false)
	if body.is_in_group("Player") and is_active:
		AudioController.play_sound("LaserCollision")
		body.handleDeath()
#endregion

#region Helpers
func _deactivate() -> void:
	is_active = false
	sprite.play("Disabled")
	light.enabled = false

func _activate() -> void:
	is_active = true
	sprite.play("Activate")
	light.enabled = true
	just_activated = true

func _update_sound() -> void:
	if is_active and not AudioController.is_playing("LaserField"):
		AudioController.play_sound("LaserField")
	elif not is_active:
		AudioController.stop_sound("LaserField")
#endregion
