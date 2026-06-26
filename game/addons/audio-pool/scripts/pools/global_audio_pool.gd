class_name GlobalAudioPool extends BaseAudioPool
## A [BaseAudioPool] of non-positional [AudioStreamPlayer]s (global / UI / music).

func _create_player() -> Node:
	return AudioStreamPlayer.new()

func _apply_position(_player: Node, _at: Variant) -> void:
	pass
