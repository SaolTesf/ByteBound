@tool
extends EditorPlugin
## Registers the [AudioPool] autoload when the plugin is enabled.

const AUTOLOAD_NAME := "AudioPool"
const AUTOLOAD_PATH := "res://addons/audio-pool/autoloads/audio_pool.gd"

func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)

func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
