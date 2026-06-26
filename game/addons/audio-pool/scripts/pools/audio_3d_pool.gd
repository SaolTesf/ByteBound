class_name Audio3DPool extends BaseAudioPool
## A [BaseAudioPool] of [AudioStreamPlayer3D]s positioned at a [Vector3].

func _create_player() -> Node:
	return AudioStreamPlayer3D.new()

func _apply_position(player: Node, at: Variant) -> void:
	if at is Vector3:
		(player as AudioStreamPlayer3D).global_position = at
