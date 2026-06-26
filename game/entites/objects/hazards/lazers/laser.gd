class_name Laser extends Area2D
## A hazard beam toggled by buttons on its channel.
##
## Thin coordinator: wires a [ChannelReceiverComponent] to a [HazardComponent] and
## the visuals. A pedestal opens it permanently; a pressure plate opens it while held.

const LASER_FIELD: AudioPoolStream = preload("res://Assets/Audio/pool-streams/laserField.tres")

@export var hazard: HazardComponent
@export var receiver: ChannelReceiverComponent
@export var sprite: AnimatedSprite2D
@export var light: PointLight2D

var perma_open: bool = false
# Set when reactivated so _process replays "Active" after the "Activate" anim.
var just_activated: bool = false
var _laser_field_player: Node

func _ready() -> void:
	receiver.activated.connect(_on_activated)
	receiver.deactivated.connect(_on_deactivated)
	sprite.play("Active")
	light.enabled = true
	_update_sound()

func _process(_delta: float) -> void:
	if not sprite.is_playing() and just_activated:
		sprite.play("Active")
		just_activated = false
	_update_sound()

func _exit_tree() -> void:
	_stop_laser_sound()
	return

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
	if hazard.active:
		if _laser_field_player == null:
			_laser_field_player = AudioPool.play(LASER_FIELD, global_position)
		elif _laser_field_player is AudioStreamPlayer2D:
			(_laser_field_player as AudioStreamPlayer2D).global_position = global_position
		return
	_stop_laser_sound()
	return

func _stop_laser_sound() -> void:
	if _laser_field_player == null:
		return
	AudioPool.stop(_laser_field_player)
	_laser_field_player = null
	return
