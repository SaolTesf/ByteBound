extends Node2D

@export var mute: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_sound("Music")

# Get the node for the sound and play it
func play_sound(sound: String) -> void:
	var sound_node = get_node_or_null(sound)
	sound_node.play()

# Get the node for the sound and stop it
func stop_sound(sound: String) -> void:
	var sound_node = get_node_or_null(sound)
	sound_node.stop()

# Check if the sound node is playing
func is_playing(sound: String) -> bool:
	var sound_node = get_node_or_null(sound)
	return sound_node.playing