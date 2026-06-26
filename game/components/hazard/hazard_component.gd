class_name HazardComponent extends Node
## Kills the player on contact with the owning [Area2D] while [member active].

const LASER_COLLISION: AudioPoolStream = preload("res://Assets/Audio/pool-streams/laserCollision.tres")

@export var area: Area2D

var active: bool = true

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(b: Node2D) -> void:
	if active and b.is_in_group("Player"):
		AudioPool.play(LASER_COLLISION, area.global_position)
		b.handleDeath()
