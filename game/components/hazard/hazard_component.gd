class_name HazardComponent extends Node
## Kills the player on contact with the owning [Area2D] while [member active].

@export var area: Area2D

var active: bool = true

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(b: Node2D) -> void:
	if active and b.is_in_group("Player"):
		AudioController.play_sound("LaserCollision")
		b.handleDeath()
