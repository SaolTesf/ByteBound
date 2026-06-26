class_name PickupComponent extends Node
## Makes a [RigidBody2D] pick-up-able by a character's [HolderComponent].
##
## On "interact" while the player is in range and the holder is free, the body is
## carried (reparented to the holder, frozen, collision off). Pressing again drops
## it. A separate [ThrowComponent] launches it via [method drop].

signal picked_up
signal dropped

@export var body: RigidBody2D
@export var collision: CollisionShape2D
@export var hitbox: Hitbox

var is_held: bool = false
var holder: HolderComponent
var _in_range: bool = false

func _ready() -> void:
	hitbox.init()
	hitbox.entered.connect(_on_hitbox_entered)
	hitbox.exited.connect(_on_hitbox_exited)

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	if is_held:
		drop()
	elif _in_range and holder and holder.is_free():
		pick_up()

func pick_up() -> void:
	is_held = true
	holder.grab(self)
	body.freeze = true
	collision.disabled = true
	_finish_pick_up.call_deferred()
	picked_up.emit()

## Drops the body back into the level, optionally launching it with [param impulse].
func drop(impulse: Vector2 = Vector2.ZERO) -> void:
	if not is_held:
		return
	is_held = false
	collision.disabled = false
	var level := holder.body.get_parent()
	holder.release()
	_finish_drop.call_deferred(level, impulse)
	dropped.emit()

func _finish_pick_up() -> void:
	body.reparent(holder)
	body.global_position = holder.global_position

func _finish_drop(level: Node, impulse: Vector2) -> void:
	body.reparent(level)
	body.freeze = false
	if impulse != Vector2.ZERO:
		# Wait a physics step so the body is active before the launch impulse;
		# applying it the same frame the body unfreezes gets dropped.
		await get_tree().physics_frame
		body.apply_impulse(impulse)

func _on_hitbox_entered(b: Node2D) -> void:
	if b is Player:
		_in_range = true
		holder = (b as Player).hand

func _on_hitbox_exited(b: Node2D) -> void:
	if b is Player:
		_in_range = false
		if not is_held:
			holder = null
