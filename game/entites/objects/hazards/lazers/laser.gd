class_name Laser extends Area2D
## A hazard beam toggled by buttons on its channel.
##
## Thin coordinator: wires a [ChannelReceiverComponent] to a [HazardComponent] and
## the visuals. A pedestal opens it permanently; a pressure plate opens it while held.

@export var hazard: HazardComponent
@export var receiver: ChannelReceiverComponent
@export var sprite: AnimatedSprite2D
@export var light: PointLight2D

var perma_open: bool = false
# Set when reactivated so _process replays "Active" after the "Activate" anim.
var just_activated: bool = false

func _ready() -> void:
	receiver.activated.connect(_on_activated)
	receiver.deactivated.connect(_on_deactivated)
	sprite.play("Active")
	light.enabled = true
	AudioController.play_sound("LaserField")

func _process(_delta: float) -> void:
	if not sprite.is_playing() and just_activated:
		sprite.play("Active")
		just_activated = false
	_update_sound()

func _on_activated(by_pedestal: bool) -> void:
	if by_pedestal:
		perma_open = true
		if hazard.active:
			_deactivate()
	elif hazard.active and not perma_open:
		_deactivate()

func _on_deactivated() -> void:
	if not hazard.active and not perma_open:
		_activate()

func _deactivate() -> void:
	hazard.active = false
	sprite.play("Disabled")
	light.enabled = false

func _activate() -> void:
	hazard.active = true
	sprite.play("Activate")
	light.enabled = true
	just_activated = true

func _update_sound() -> void:
	if hazard.active and not AudioController.is_playing("LaserField"):
		AudioController.play_sound("LaserField")
	elif not hazard.active:
		AudioController.stop_sound("LaserField")
