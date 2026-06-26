class_name Audio2DPool extends BaseAudioPool
## A [BaseAudioPool] of [AudioStreamPlayer2D]s positioned at a [Vector2].

func _create_player() -> Node:
	return AudioStreamPlayer2D.new()

func _apply_position(player: Node, at: Variant) -> void:
	if at is Vector2:
		(player as AudioStreamPlayer2D).global_position = at
