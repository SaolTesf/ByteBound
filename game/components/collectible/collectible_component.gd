class_name CollectibleComponent extends Node
## A pickup the player collects on contact: fires the game's key-collected event
## and frees its owner. (ByteBound's one collectible is the key card.)

signal collected

@export var owner_body: Node
@export var hitbox: Hitbox

func _ready() -> void:
	hitbox.init()
	hitbox.entered.connect(_on_hitbox_entered)

func _on_hitbox_entered(b: Node2D) -> void:
	if b.is_in_group("Player"):
		collected.emit()
		SignalHub.key_collected.emit()
		owner_body.queue_free()
